//
//  SoundsViewController.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.04.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class SoundsViewController: UIViewController {
    lazy var viewportView = makeViewportView()
    
    @IBOutlet private var addSoundButton: UIButton!
    @IBOutlet private var emptyView: UIView!
    
    private lazy var viewModel = SoundsViewModel()
    
    private let sounds = BehaviorRelay<Set<Noise>>(value: [])
    private let disposeBag = DisposeBag()
    
    private let soundsListView = SoundsListView()
    private let closeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeConstraints()
        
        closeButton.setImage(UIImage(named: "close_sounds"), for: .normal)
        
        let elements = viewModel.sounds()
        
        let selectedCellModel = soundsListView
            .selectedItem
        
        let selectedNoise = selectedCellModel
            .filter { $0.paid }
            .map { $0.noise }
        
        elements
            .drive(onNext: { [weak self] noiseCategories in
                self?.soundsListView.setup(noiseCategories: noiseCategories, isActiveSubscription: true)
            })
            .disposed(by: disposeBag)
        
        let addSound = selectedNoise.map { NoiseAction.add($0) }
        let deleteSound = viewportView.deletedSound.map { NoiseAction.delete($0) }
        
        Observable<NoiseAction>
            .merge(addSound, deleteSound)
            .scan([Noise]()) { old, action -> [Noise] in
                var result = old
                switch action {
                case let .add(noise):
                    result.append(noise)
                case let .delete(id):
                    result.removeAll(where: { $0.id == id })
                }
                return result
            }
            .map { Set($0) }
            .bind(to: sounds)
            .disposed(by: disposeBag)

        selectedNoise
            .bind(to: viewportView.item)
            .disposed(by: disposeBag)
        
        let userAction = Observable<UserAction>
            .merge(
                viewportView.didTapAdd.asObservable().map { _ in .add },
                addSoundButton.rx.tap.map { _ in .add },
                closeButton.rx.tap.map { _ in .close },
                selectedNoise.map { _ in .close }
            )
        
        userAction
            .withLatestFrom(sounds) { ($0, $1) }
            .bind(to: Binder(self) { base, elements in
                base.showSoundsList(action: elements.0, isEmpty: elements.1.isEmpty)
            })
            .disposed(by: disposeBag)
        
        let noiseSounds = sounds
            .map { sounds -> Set<NoiseSound> in
                return sounds
                    .map { $0.sounds }
                    .reduce(Set<NoiseSound>()) { $0.union($1) }
            }
            .share(replay: 1, scope: .forever)
        
        noiseSounds.asDriver(onErrorDriveWith: .empty())
            .filter { !$0.isEmpty }
            .map { _ in Void() }
            .drive(viewModel.playNoise)
            .disposed(by: disposeBag)
        
        viewportView.changeVolume
            .emit(to: viewModel.noiseVolume)
            .disposed(by: disposeBag)
        
        let loadableSounds = BehaviorRelay<Set<Int>>(value: Set<Int>())
        let loadedSounds = BehaviorRelay<Set<Int>>(value: Set<Int>())
        
        //массив с id загружающихся звуков
        Driver
            .combineLatest(
                noiseSounds.map { Set($0.map { $0.id }) }.asDriver(onErrorDriveWith: .empty()),
                loadableSounds.asDriver()
            ) { Array($0.intersection($1)) }
            .distinctUntilChanged()
            .drive(viewportView.loadingSounds)
            .disposed(by: disposeBag)
        
        noiseSounds
            .withLatestFrom(loadableSounds.asDriver()) { ($0, $1) }
            .withLatestFrom(loadedSounds.asDriver()) { ($0.0, $0.1, $1) }
            .map { noises, loadable, loaded -> ([NoiseSound], Set<Int>)  in
                
                let ids = Set(noises.map { $0.id }).subtracting(loadable)
                    .subtracting(loaded)
                return (noises.filter { ids.contains($0.id) }, loadable)
            }
            .do(onNext: { noises, loadable in
                loadableSounds.accept(loadable.union(noises.map { $0.id }))
            })
            .flatMap { [weak self] tuple -> Signal<[Int]> in
                guard let self = self else {
                    return .never()
                }
                
                return self.viewModel.copy(url: tuple.0.map { $0.soundUrl })
                    .map { _ in tuple.0.map { $0.id } }
            }
            .withLatestFrom(loadedSounds.asDriver()) { $1.union($0) }
            .asSignal(onErrorSignalWith: .empty())
            .emit(to: loadedSounds)
            .disposed(by: disposeBag)
        
        loadedSounds.asDriver()
            .withLatestFrom(loadableSounds.asDriver()) { $1.subtracting($0) }
            .drive(loadableSounds)
            .disposed(by: disposeBag)
        
        Driver
            .combineLatest(
                noiseSounds.asDriver(onErrorDriveWith: .empty()),
                loadedSounds.asDriver()
            ) { noises, loaded in
                noises.filter { loaded.contains($0.id) }
            }
            .distinctUntilChanged()
            .flatMap { [weak self] noises -> Driver<Never> in
                guard let self = self else {
                    return .never()
                }
                
                return self.viewModel.add(noises: noises).asDriver(onErrorDriveWith: .empty())
            }
            .drive()
            .disposed(by: disposeBag)
        
        viewportView
            .didTapSleepTimer
            .emit(onNext: { [weak self] in
                self?.viewModel.showSleepTimerScreen()
                
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension SoundsViewController {
    static func make() -> SoundsViewController {
        let storyboard = UIStoryboard(name: "SoundsScreen", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SoundsViewController") as! SoundsViewController
    }
}

private extension SoundsViewController {
    enum UserAction {
        case add
        case close
    }
    
    enum NoiseAction {
        case add(Noise)
        case delete(Int)
    }
    
    func showSoundsList(action: UserAction, isEmpty: Bool) {
        viewportView.isHidden = isEmpty
        emptyView.isHidden = !isEmpty
        switch action {
        case .add:
            soundsListView.frame = view.frame
            closeButton.frame = CGRect(origin: CGPoint(x: view.frame.width - 50.18, y: 50), size: CGSize(width: 32, height: 32))
            closeButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            view.addSubview(soundsListView)
            view.addSubview(closeButton)
            let originY = view.frame.origin.y + 88
            soundsListView.frame.size.height -= 88
            soundsListView.frame.origin.y += view.frame.height

            UIView.animate(withDuration: 0.5) {
                self.soundsListView.frame.origin.y = originY
                self.closeButton.transform = .identity
                if isEmpty {
                    self.emptyView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
                    self.addSoundButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                } else {
                    self.viewportView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
                }
            }
            
        case .close:
            UIView.animate(withDuration: 0.5, animations: {
                self.closeButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.soundsListView.frame.origin.y += self.view.frame.height
                if isEmpty {
                    self.emptyView.transform = .identity
                    self.addSoundButton.transform = .identity
                } else {
                    self.viewportView.transform = .identity
                }
            }) { _ in
                self.closeButton.transform = .identity
                self.closeButton.removeFromSuperview()
                self.soundsListView.removeFromSuperview()
            }
        }
    }
}

// MARK: Make constraints
private extension SoundsViewController {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            viewportView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewportView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewportView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewportView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SoundsViewController {
    func makeViewportView() -> ViewportView {
        let view = ViewportView()
        view.backgroundColor = Appearance.background
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
}

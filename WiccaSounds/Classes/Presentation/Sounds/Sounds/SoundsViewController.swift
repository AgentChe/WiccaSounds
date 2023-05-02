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
    lazy var mainView = SoundsView()
    
    private enum NoiseAction {
        case add(Noise)
        case delete(Int)
    }
    
    private lazy var viewModel = SoundsViewModel()
    
    private let sounds = BehaviorRelay<Set<Noise>>(value: [])
    private let disposeBag = DisposeBag()
    
    private lazy var didSelectSoundItemTrigger = PublishRelay<SoundCellElement>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared.logEvent(name: "Ambience Screen")
        
        let selectedCellModel = didSelectSoundItemTrigger
        
        let selectedNoise = selectedCellModel
            .filter { $0.isActiveSubscription }
            .map { $0.noise }
        
        Observable
            .merge(
                mainView.emptyView.addButton.rx.tap.asObservable(),
                mainView.viewportView.didTapAdd.asObservable()
            )
            .bind(to: Binder(self) { base, void in
                let vc = SelectSoundViewController.make { [weak self] element in
                    self?.didSelectSoundItemTrigger.accept(element)
                }
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        let addSound = selectedNoise.map { NoiseAction.add($0) }
        let deleteSound = mainView.viewportView.deletedSound.map { NoiseAction.delete($0) }
        
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
            .bind(to: mainView.viewportView.item)
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
        
        noiseSounds
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(mainView) { base, sounds in
                let isEmpty = sounds.isEmpty
                base.emptyView.isHidden = !isEmpty
                base.viewportView.isHidden = isEmpty
            })
            .disposed(by: disposeBag)
        
        mainView.viewportView.changeVolume
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
            .drive(mainView.viewportView.loadingSounds)
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
    }
}

// MARK: Make
extension SoundsViewController {
    static func make() -> SoundsViewController {
        let vc = SoundsViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

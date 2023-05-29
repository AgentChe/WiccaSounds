//
//  StoryCardViewController.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 25.10.2022.
//

import UIKit
import RxSwift

final class StoryCardViewController: UIViewController {
    lazy var mainView = StoryCardView()
    
    private lazy var disposeBag = DisposeBag()
    
    private let viewModel: StoryCardViewModel
    
    private init(storyCover: StoryCover) {
        viewModel = StoryCardViewModel(storyCover: storyCover)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared.logEvent(name: "Insight Screen")
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.open(error: error)
        }
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                AmplitudeManager.shared.logEvent(name: "Insight Tap", parameters: ["what": "close"])
                
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.previousButton.rx.tap
            .do(onNext: {
                AmplitudeManager.shared.logEvent(name: "Insight Tap", parameters: ["what": "back"])
            })
            .bind(to: viewModel.didTappedPrevious)
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .do(onNext: {
                AmplitudeManager.shared.logEvent(name: "Insight Tap", parameters: ["what": "next"])
            })
            .bind(to: viewModel.didTappedNext)
            .disposed(by: disposeBag)
        
        viewModel.cardsCount
            .drive(Binder(mainView.stepsView) { base, count in
                base.set(count: count)
            })
            .disposed(by: disposeBag)
        
        viewModel.currentIndex
            .drive(Binder(mainView.stepsView) { base, currentIndex in
                base.set(index: currentIndex)
            })
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
                
        addTableCenterTapAction()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: Make
extension StoryCardViewController {
    static func make(storyCover: StoryCover) -> StoryCardViewController {
        StoryCardViewController(storyCover: storyCover)
    }
}

// MARK: Private
private extension StoryCardViewController {
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
    
    func addTableCenterTapAction() {
        let gesture = UITapGestureRecognizer()
        gesture.rx.event
            .mapToVoid()
            .bind(to: viewModel.didTappedNext)
            .disposed(by: disposeBag)
        
        mainView.tableView.addGestureRecognizer(gesture)
    }
    
    func activity(_ activity: Bool) {
        mainView.tableView.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}

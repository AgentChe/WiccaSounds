//
//  MainViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    lazy var mainView = MainView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coordinator = MainViewCoordinator(parentVC: self)
    
    private let requestReview: Bool
    
    private init(requestReview: Bool) {
        self.requestReview = requestReview
        
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
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.update(selectedTab: .home)
            })
            .disposed(by: disposeBag)
        
        let isEmptyNoisePlaying = AudioPlayerService.shared
            .isEmptyNoisePlaying
            .asDriver(onErrorDriveWith: .never())
        
        isEmptyNoisePlaying
            .drive(Binder(mainView.tabView) { base, isEmptyNoisePlaying in
                base.draw(with: !isEmptyNoisePlaying)
            })
            .disposed(by: disposeBag)
        
        let isNoisePlaying = AudioPlayerService.shared
            .isNoisePlaying
        
        isNoisePlaying
            .drive(Binder(mainView.tabView) { base, isPlaying in
                base.updatePlauPauseButton(isPlaying: isPlaying)
            })
            .disposed(by: disposeBag)
        
        mainView.tabView
            .playPauseView.playPauseButton.rx.tap
            .withLatestFrom(isEmptyNoisePlaying)
            .filter { !$0 }
            .withLatestFrom(isNoisePlaying)
            .asDriver(onErrorDriveWith: .never())
            .drive(Binder(AudioPlayerService.shared) { base, isPlaying in
                isPlaying ? base.forcePauseNoise() : base.forcePlayNoise()
            })
            .disposed(by: disposeBag)
        
        requestReviewIfNeeded()
        addActionsToTabs()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: Make
extension MainViewController {
    static func make(requestReview: Bool = false) -> MainViewController {
        let vc = MainViewController(requestReview: requestReview)
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension MainViewController {
    func requestReviewIfNeeded() {
        guard requestReview else {
            return
        }

        RequestReview.request()
    }
    
    func addActionsToTabs() {
        Observable
            .merge([
                mainView.tabView.homeItem
                    .rx.tap.map { TabView.Tab.home },
                mainView.tabView.exploreItem
                    .rx.tap.map { TabView.Tab.explore },
                mainView.tabView.practiceItem
                    .rx.tap.map { TabView.Tab.practice },
                mainView.tabView.ambienceItem
                    .rx.tap.map { TabView.Tab.ambience }
            ])
            .subscribe(onNext: { [weak self] tab in
                self?.update(selectedTab: tab)
            })
            .disposed(by: disposeBag)
    }
    
    func update(selectedTab: TabView.Tab) {
        coordinator.change(tab: selectedTab)
    }
}

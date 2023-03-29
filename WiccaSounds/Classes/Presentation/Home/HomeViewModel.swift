//
//  HomeViewModel.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.03.2023.
//

import RxSwift
import RxCocoa

final class HomeViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didTapTip = PublishRelay<LunarTip>()
    
    lazy var sections = makeSections()
    lazy var activity = RxActivityIndicator()
    
    private lazy var homeKit = makeHomeKit()
    private lazy var selectedTip = makeSelectedTip()
    private lazy var activeSubscription = makeActiveSubscription()
    
    private lazy var contentManager = ContentManager()
    private lazy var sessionManager = SessionManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension HomeViewModel {
    func makeSections() -> Driver<[HomeTableSection]> {
        Driver
            .combineLatest(homeKit, activeSubscription, selectedTip)
            .map { homeKit, activeSubscription, selectedTip -> [HomeTableSection] in
                var sections = [HomeTableSection]()
                
                let todayTitleSection = HomeTableSection(
                    elements: [.todayTitle],
                    corner: false
                )
                sections.append(todayTitleSection)
                
                let todaySection = HomeTableSection(
                    elements: [
                        .spell(homeKit.spellOnDay),
                        .stories(homeKit.stories)
                    ],
                    corner: true
                )
                sections.append(todaySection)
                
                var lunarSectionElements: [HomeTableElement] = [
                    .lunar(homeKit.lunar),
                    .tips(homeKit.lunar.tips.map { tip -> HomeTipElement in
                        HomeTipElement(
                            tip: tip,
                            locked: tip.paid ? !activeSubscription : false
                        )
                    })
                ]
                if let selectedTip = selectedTip {
                    lunarSectionElements.append(.tipContent(selectedTip))
                }
                let lunarSection = HomeTableSection(
                    elements: lunarSectionElements,
                    corner: true
                )
                sections.append(lunarSection)
                
                return sections
            }
    }
    
    func makeHomeKit() -> Driver<HomeKit> {
        func source() -> Single<HomeKit> {
            contentManager
                .obtainHomeKit()
                .map { homeKit -> HomeKit in
                    guard let homeKit = homeKit else {
                        throw ContentError(.notContent)
                    }
                    
                    return homeKit
                }
        }
        
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = self.tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        return self.observableRetrySingle
            .retry(source: { source() },
                   trigger: { trigger(error: $0) })
            .trackActivity(activity)
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeSelectedTip() -> Driver<LunarTip?> {
        let initial = homeKit
            .map { homeKit -> LunarTip? in
                homeKit.lunar.tips.filter { !$0.paid }.first
            }
        
        let action = didTapTip
            .asDriver(onErrorDriveWith: .never())
            .map { tip -> LunarTip? in
                tip
            }
        
        return Driver
            .merge(initial, action)
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { [weak self] in
                guard let self = self else {
                    return false
                }
                
                return self.sessionManager.hasActiveSubscriptions()
            }
            .startWith(sessionManager.hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
    }
}

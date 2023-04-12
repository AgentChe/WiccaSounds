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
    lazy var didOpenTarot = PublishRelay<TarotOnDay>()
    lazy var didOpenRune = PublishRelay<RuneOnDay>()
    
    lazy var sections = makeSections()
    lazy var activity = RxActivityIndicator()
    
    private lazy var homeKit = makeHomeKit()
    private lazy var tarotOnToday = makeTarotOnToday()
    private lazy var runeOnToday = makeRuneOnToday()
    private lazy var selectedTip = makeSelectedTip()
    private lazy var activeSubscription = makeActiveSubscription()
    
    private lazy var contentManager = ContentManager()
    private lazy var sessionManager = SessionManager()
    private lazy var tarotManager = TarotManager()
    private lazy var runeManager = RunesManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension HomeViewModel {
    func makeSections() -> Driver<[HomeTableSection]> {
        Driver
            .combineLatest(homeKit, activeSubscription, selectedTip, tarotOnToday, runeOnToday)
            .map { homeKit, activeSubscription, selectedTip, tarotOnToday, runeOnToday -> [HomeTableSection] in
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
                
                let practice = HomePracticeElement(
                    tarotOnToday: tarotOnToday,
                    runeOnToday: runeOnToday
                )
                let practiceSection = HomeTableSection(
                    elements: [.practice(practice)],
                    corner: true
                )
                sections.append(practiceSection)
                
                let wheelSection = HomeTableSection(
                    elements: [.wheel(homeKit.wheel)],
                    corner: true
                )
                sections.append(wheelSection)
                
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
    
    func makeTarotOnToday() -> Driver<TarotOnDay> {
        let tarots = tarotManager
            .obtainCovers(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
        let tarotOnToday = tarotManager
            .obtainTarotOnToday()
            .asDriver(onErrorJustReturn: nil)
        
        let set = didOpenTarot
            .flatMapLatest { [weak self] tarotOnToday -> Single<TarotOnDay> in
                guard let self = self else {
                    return .never()
                }
                
                let new = TarotOnDay(
                    tarot: tarotOnToday.tarot,
                    onDay: tarotOnToday.onDay,
                    isOpened: true
                )
                
                return self.tarotManager
                    .set(tarotOnToday: new)
                    .map { new }
                    .flatMap { object -> Single<TarotOnDay> in
                        .never()
                    }
            }
            .asDriver(onErrorDriveWith: .never())
        
        let tarot = Driver
            .combineLatest(tarots, tarotOnToday)
            .flatMapLatest { [weak self] tarots, tarotOnToday -> Driver<TarotOnDay> in
                guard let self = self else {
                    return .never()
                }
                
                if let tarotOnToday = tarotOnToday {
                    return .just(tarotOnToday)
                }
                
                guard let tarot = tarots.randomElement() else {
                    return .never()
                }
                
                let new = TarotOnDay(
                    tarot: tarot,
                    onDay: Date(),
                    isOpened: false
                )
                
                return self.tarotManager
                    .set(tarotOnToday: new)
                    .map { new }
                    .asDriver(onErrorJustReturn: new)
            }
        
        return Driver
            .merge(set, tarot)
    }
    
    func makeRuneOnToday() -> Driver<RuneOnDay> {
        let runes = runeManager
            .obtainCovers(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
        let runeOnToday = runeManager
            .obtainRuneOnToday()
            .asDriver(onErrorJustReturn: nil)
        
        let set = didOpenRune
            .flatMapLatest { [weak self] runeOnToday -> Single<RuneOnDay> in
                guard let self = self else {
                    return .never()
                }
                
                let new = RuneOnDay(
                    rune: runeOnToday.rune,
                    onDay: runeOnToday.onDay,
                    isOpened: true
                )
                
                return self.runeManager
                    .set(runeOnToday: new)
                    .map { new }
                    .flatMap { object -> Single<RuneOnDay> in
                        .never()
                    }
            }
            .asDriver(onErrorDriveWith: .never())
        
        let rune = Driver
            .combineLatest(runes, runeOnToday)
            .flatMapLatest { [weak self] runes, runeOnToday -> Driver<RuneOnDay> in
                guard let self = self else {
                    return .never()
                }
                
                if let runeOnToday = runeOnToday {
                    return .just(runeOnToday)
                }
                
                guard let rune = runes.randomElement() else {
                    return .never()
                }
                
                let new = RuneOnDay(
                    rune: rune,
                    onDay: Date(),
                    isOpened: false
                )
                
                return self.runeManager
                    .set(runeOnToday: new)
                    .map { new }
                    .asDriver(onErrorJustReturn: new)
            }
        
        return Driver
            .merge(set, rune)
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

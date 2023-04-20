//
//  PracticeViewModel.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import RxSwift
import RxCocoa

final class PracticeViewModel {
    lazy var didSelectUnit = PublishRelay<PracticeUnitView.Unit>()
    
    lazy var elements = makeElements()
    
    private lazy var tarotElements = makeTarotElements()
    private lazy var runesElements = makeRunesElements()
    private lazy var activeSubscription = makeActiveSubscription()
    
    private lazy var tarotManager = TarotManager()
    private lazy var runesManager = RunesManager()
    private lazy var sessionManager = SessionManager()
}

// MARK: Private
private extension PracticeViewModel {
    func makeElements() -> Driver<[PracticeCollectionElement]> {
        Driver
            .combineLatest(
                didSelectUnit.asDriver(onErrorDriveWith: .never()),
                tarotElements,
                runesElements
            )
            .map { unit, tarots, runes -> [PracticeCollectionElement] in
                switch unit {
                case .tarot:
                    return tarots
                case .runes:
                    return runes
                }
            }
    }
    
    func makeTarotElements() -> Driver<[PracticeCollectionElement]> {
        let tarots = tarotManager
            .obtainCovers(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
        
        return Driver
            .combineLatest(
                activeSubscription,
                tarots
            )
            .map { activeSubscription, tarots -> [PracticeCollectionElement] in
                tarots.map { tarot -> PracticeCollectionElement in
                    let element = PracticeTarotElement(
                        tarot: tarot,
                        paid: tarot.paid ? !activeSubscription : false
                    )
                    return .tarot(element)
                }
            }
    }
    
    func makeRunesElements() -> Driver<[PracticeCollectionElement]> {
        let runes = runesManager
            .obtainCovers(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
        
        return Driver
            .combineLatest(
                activeSubscription,
                runes
            )
            .map { activeSubscription, runes -> [PracticeCollectionElement] in
                runes.map { rune -> PracticeCollectionElement in
                    let element = PracticeRuneElement(
                        rune: rune,
                        paid: rune.paid ? !activeSubscription : false
                    )
                    return .rune(element)
                }
            }
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

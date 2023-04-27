//
//  SelectSoundViewModel.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 27.04.2023.
//

import RxSwift
import RxCocoa

final class SelectSoundViewModel {
    lazy var bundle = makeBundle()
    
    private lazy var categories = makeCategories()
    private lazy var activeSubscription = makeActiveSubscription()
    
    private lazy var noiseManager = NoiseManager()
    private lazy var sessionManager = SessionManager()
}

// MARK: Private
private extension SelectSoundViewModel {
    func makeBundle() -> Driver<([NoiseCategory], Bool)> {
        Driver
            .combineLatest(categories, activeSubscription)
    }
    
    func makeCategories() -> Driver<[NoiseCategory]> {
        noiseManager
            .obtainNoiseCategories(forceUpdate: false)
            .map { $0.sorted(by: { $0.sort < $1.sort }) }
            .asDriver(onErrorJustReturn: [])
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

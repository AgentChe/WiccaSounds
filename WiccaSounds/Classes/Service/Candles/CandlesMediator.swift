//
//  CandlesMediator.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import RxSwift
import RxCocoa

final class CandlesMediator {
    static let shared = CandlesMediator()
    
    private lazy var didSaveCandleTrigger = PublishRelay<Int>()
    private lazy var didUnsaveCandleTrigger = PublishRelay<Int>()
    
    private init() {}
}

// MARK: Public
extension CandlesMediator {
    func didSave(candleId: Int) {
        DispatchQueue.main.async {
            Self.shared.didSaveCandleTrigger.accept(candleId)
        }
    }
    
    func didUnsave(candleId: Int) {
        DispatchQueue.main.async {
            Self.shared.didUnsaveCandleTrigger.accept(candleId)
        }
    }
    
    var didSaveCandle: Signal<Int> {
        didSaveCandleTrigger.asSignal()
    }
    
    var didUnsaveCandle: Signal<Int> {
        didUnsaveCandleTrigger.asSignal()
    }
}

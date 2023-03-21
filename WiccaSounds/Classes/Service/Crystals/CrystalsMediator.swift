//
//  CrystalsMediator.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import RxSwift
import RxCocoa

final class CrystalsMediator {
    static let shared = CrystalsMediator()
    
    private lazy var didSaveCrystalTrigger = PublishRelay<Int>()
    private lazy var didUnsaveCrystalTrigger = PublishRelay<Int>()
    
    private init() {}
}

// MARK: Public
extension CrystalsMediator {
    func didSave(crystalId: Int) {
        DispatchQueue.main.async {
            Self.shared.didSaveCrystalTrigger.accept(crystalId)
        }
    }
    
    func didUnsave(crystalId: Int) {
        DispatchQueue.main.async {
            Self.shared.didUnsaveCrystalTrigger.accept(crystalId)
        }
    }
    
    var didSaveCrystal: Signal<Int> {
        didSaveCrystalTrigger.asSignal()
    }
    
    var didUnsaveCrystal: Signal<Int> {
        didUnsaveCrystalTrigger.asSignal()
    }
}

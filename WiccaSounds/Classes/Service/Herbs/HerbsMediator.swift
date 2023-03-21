//
//  HerbsMediator.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import RxSwift
import RxCocoa

final class HerbsMediator {
    static let shared = HerbsMediator()
    
    private lazy var didSaveHerbTrigger = PublishRelay<Int>()
    private lazy var didUnsaveHerbTrigger = PublishRelay<Int>()
    
    private init() {}
}

// MARK: Public
extension HerbsMediator {
    func didSave(herbId: Int) {
        DispatchQueue.main.async {
            Self.shared.didSaveHerbTrigger.accept(herbId)
        }
    }
    
    func didUnsave(herbId: Int) {
        DispatchQueue.main.async {
            Self.shared.didUnsaveHerbTrigger.accept(herbId)
        }
    }
    
    var didSaveHerb: Signal<Int> {
        didSaveHerbTrigger.asSignal()
    }
    
    var didUnsaveHerb: Signal<Int> {
        didUnsaveHerbTrigger.asSignal()
    }
}

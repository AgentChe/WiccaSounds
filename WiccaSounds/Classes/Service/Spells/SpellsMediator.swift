//
//  SpellsMediator.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import RxSwift
import RxCocoa

final class SpellsMediator {
    static let shared = SpellsMediator()
    
    private lazy var didSaveSpellTrigger = PublishRelay<Int>()
    private lazy var didUnsaveSpellTrigger = PublishRelay<Int>()
    
    private init() {}
}

// MARK: Public
extension SpellsMediator {
    func didSave(spellId: Int) {
        DispatchQueue.main.async {
            Self.shared.didSaveSpellTrigger.accept(spellId)
        }
    }
    
    func didUnsave(spellId: Int) {
        DispatchQueue.main.async {
            Self.shared.didUnsaveSpellTrigger.accept(spellId)
        }
    }
    
    var didSaveSpell: Signal<Int> {
        didSaveSpellTrigger.asSignal()
    }
    
    var didUnsaveSpell: Signal<Int> {
        didUnsaveSpellTrigger.asSignal()
    }
}

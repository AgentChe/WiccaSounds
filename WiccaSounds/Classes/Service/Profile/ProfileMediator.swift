//
//  ProfileMediator.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2023.
//

import RxSwift
import RxCocoa

final class ProfileMediator {
    static let shared = ProfileMediator()
    
    private lazy var spellsCategoriesIdsChangeTrigger = PublishRelay<[Int]>()
    
    private init() {}
}

// MARK: Public
extension ProfileMediator {
    func notify(spellsCategoriesIds: [Int]) {
        DispatchQueue.main.async { [weak self] in
            self?.spellsCategoriesIdsChangeTrigger.accept(spellsCategoriesIds)
        }
    }
}

// MARK: Public (Rx)
extension ProfileMediator {
    var spellsCategoriesIdsChange: Signal<[Int]> {
        spellsCategoriesIdsChangeTrigger.asSignal()
    }
}

//
//  SpellsManager.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.03.2023.
//

import RxSwift

protocol SpellsManagerProtocol {
    func obtainCategories(forceUpdate: Bool) -> Single<[SpellsCategory]>
    func obtainSpells(forceUpdate: Bool) -> Single<[Spell]>
    func save(spellId: Int) -> Single<Void>
    func unsave(spellId: Int) -> Single<Void>
}

final class SpellsManager {
    enum Constants {
        static let categoriesKey = "spells_manager_categories_key"
        static let spellsKey = "spells_manager_spells_key"
    }
    
    private lazy var sessionManager = SessionManager()
    
    private lazy var defaultWrapper = DefaultRequestWrapper()
}

// MARK: SpellsManagerProtocol
extension SpellsManager: SpellsManagerProtocol {
    func obtainCategories(forceUpdate: Bool) -> Single<[SpellsCategory]> {
        forceUpdate ? loadCategories() : cachedCategories()
    }
    
    func obtainSpells(forceUpdate: Bool) -> Single<[Spell]> {
        forceUpdate ? loadSpells() : cachedSpells()
    }
    
    func save(spellId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SaveSpellRequest(
            userToken: userToken,
            spellId: spellId
        )
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func unsave(spellId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = UnsaveSpellRequest(
            userToken: userToken,
            spellId: spellId
        )
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
}

// MARK: Private
private extension SpellsManager {
    func loadCategories() -> Single<[SpellsCategory]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetSpellsCategoriesRequest(userToken: userToken)
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .map { GetSpellsCategoriesResponse.map(from: $0) }
            .do(onSuccess: { categories in
                guard let data = try? JSONEncoder().encode(categories) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.categoriesKey)
            })
    }
    
    func cachedCategories() -> Single<[SpellsCategory]> {
        Single<[SpellsCategory]>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.categoriesKey),
                let categories = try? JSONDecoder().decode([SpellsCategory].self, from: data)
            else {
                event(.success([]))
                return Disposables.create()
            }
            
            event(.success(categories))
            
            return Disposables.create()
        }
    }
    
    func loadSpells() -> Single<[Spell]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetSpellsRequest(userToken: userToken)
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .map { GetSpellsResponse.map(from: $0) }
            .do(onSuccess: { spells in
                guard let data = try? JSONEncoder().encode(spells) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.spellsKey)
            })
    }
    
    func cachedSpells() -> Single<[Spell]> {
        Single<[Spell]>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.spellsKey),
                let spells = try? JSONDecoder().decode([Spell].self, from: data)
            else {
                event(.success([]))
                return Disposables.create()
            }
            
            event(.success(spells))
            
            return Disposables.create()
        }
    }
}

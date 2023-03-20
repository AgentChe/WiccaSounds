//
//  SpellsManager.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.03.2023.
//

import RxSwift

protocol SpellsManagerProtocol {
    func obtainCategories(forceUpdate: Bool) -> Single<[SpellsCategory]>
}

final class SpellsManager {
    enum Constants {
        static let categoriesKey = "spells_manager_categories_key"
    }
    
    private lazy var sessionManager = SessionManager()
    
    private lazy var defaultWrapper = DefaultRequestWrapper()
}

// MARK: SpellsManagerProtocol
extension SpellsManager: SpellsManagerProtocol {
    func obtainCategories(forceUpdate: Bool) -> Single<[SpellsCategory]> {
        forceUpdate ? loadCategories() : cachedCategories()
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
}

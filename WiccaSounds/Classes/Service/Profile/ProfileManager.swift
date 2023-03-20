//
//  ProfileManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import RxSwift

protocol ProfileManagerProtocol {
    func set(spellsCategoriesIds: [Int]?) -> Single<Void>
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?>
    func syncTokens(oldToken: String, newToken: String) -> Single<Void>
    func login(userToken: String) -> Single<Void>
}

final class ProfileManager {
    enum Constants {
        static let spellsCategoriesIds = "profile_manager_spells_categories_ids_key"
    }
    
    private lazy var defaultRequestWrapper = DefaultRequestWrapper()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: ProfileManagerProtocol
extension ProfileManager: ProfileManagerProtocol {
    func set(spellsCategoriesIds: [Int]?) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetProfileRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: { [weak self] in
                self?.store(spellsCategoriesIds: spellsCategoriesIds)
            })
    }
    
    func obtainProfile(forceUpdate: Bool) -> Single<Profile?> {
        forceUpdate ? loadProfile() : cachedProfile()
    }
    
    func syncTokens(oldToken: String, newToken: String) -> Single<Void> {
        let request = SyncTokensRequest(oldToken: oldToken,
                                        newToken: newToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
    
    func login(userToken: String) -> Single<Void> {
        let request = LoginRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
    }
}

// MARK: Private
private extension ProfileManager {
    func loadProfile() -> Single<Profile?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetProfileRequest(userToken: userToken)
        
        return defaultRequestWrapper
            .callServerApi(requestBody: request)
            .map { GetProfileResponse.map(from: $0) }
            .do(onSuccess: { [weak self] profile in
                self?.store(spellsCategoriesIds: profile?.spellsCategoriesIds)
            })
    }
    
    func cachedProfile() -> Single<Profile?> {
        cachedSpellsCategoriesIds()
            .map { spellsCategoriesIds -> Profile in
                Profile(spellsCategoriesIds: spellsCategoriesIds)
            }
    }
    
    func store(spellsCategoriesIds: [Int]?) {
        guard let spellsCategoriesIds = spellsCategoriesIds else {
            return
        }
        
        UserDefaults.standard.set(spellsCategoriesIds, forKey: Constants.spellsCategoriesIds)
        
        ProfileMediator.shared.notify(spellsCategoriesIds: spellsCategoriesIds)
    }
    
    func cachedSpellsCategoriesIds() -> Single<[Int]?> {
        Single<[Int]?>.create { event in
            let spellsCategoriesIds = UserDefaults.standard.value(forKey: Constants.spellsCategoriesIds) as? [Int]
            
            event(.success(spellsCategoriesIds))
            
            return Disposables.create()
        }
    }
}

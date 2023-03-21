//
//  HerbsManager.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import RxSwift

protocol HerbsManagerProtocol {
    func obtainHerbs(forceUpdate: Bool) -> Single<[Herb]>
    func save(herbId: Int) -> Single<Void>
    func unsave(herbId: Int) -> Single<Void>
}

final class HerbsManager {
    enum Constants {
        static let herbsKey = "herbs_manager_herbs_key"
    }
    
    private lazy var sessionManager = SessionManager()
    
    private lazy var defaultWrapper = DefaultRequestWrapper()
}

// MARK: HerbsManagerProtocol
extension HerbsManager: HerbsManagerProtocol {
    func obtainHerbs(forceUpdate: Bool) -> Single<[Herb]> {
        forceUpdate ? loadHerbs() : cachedHerbs()
    }
    
    func save(herbId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SaveHerbRequest(
            userToken: userToken,
            herbId: herbId
        )
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: {
                HerbsMediator.shared.didSave(herbId: herbId)
            })
    }
    
    func unsave(herbId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = UnsaveHerbRequest(
            userToken: userToken,
            herbId: herbId
        )
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: {
                HerbsMediator.shared.didUnsave(herbId: herbId)
            })
    }
}

// MARK: Private
private extension HerbsManager {
    func loadHerbs() -> Single<[Herb]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetHerbsRequest(userToken: userToken)
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .map { GetHerbsResponse.map(from: $0) }
            .do(onSuccess: { herbs in
                guard let data = try? JSONEncoder().encode(herbs) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.herbsKey)
            })
    }
    
    func cachedHerbs() -> Single<[Herb]> {
        Single<[Herb]>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.herbsKey),
                let herbs = try? JSONDecoder().decode([Herb].self, from: data)
            else {
                event(.success([]))
                return Disposables.create()
            }
            
            event(.success(herbs))
            
            return Disposables.create()
        }
    }
}

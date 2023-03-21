//
//  TarotManager.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import RxSwift

protocol TarotManagerProtocol: Any {
    func obtainCovers(forceUpdate: Bool) -> Single<[TarotCover]>
    func obtaitTarot(id: Int) -> Single<Tarot?>
}

final class TarotManager {
    enum Constants {
        static let coversKey = "tarot_manager_covers_key"
    }
    
    private lazy var sessionManager = SessionManager()
    
    private lazy var defaultWrapper = DefaultRequestWrapper()
}

// MARK: TarotManagerProtocol
extension TarotManager: TarotManagerProtocol {
    func obtainCovers(forceUpdate: Bool) -> Single<[TarotCover]> {
        forceUpdate ? loadCovers() : cachedCovers()
    }
    
    func obtaitTarot(id: Int) -> Single<Tarot?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetTarotRequest(
            userToken: userToken,
            tarotId: id
        )
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .map { GetTarotResponse.map(from: $0) }
    }
}

// MARK: Private
private extension TarotManager {
    func loadCovers() -> Single<[TarotCover]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetTarotCoversRequest(userToken: userToken)
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .map { GetTarotCoversResponse.map(from: $0) }
            .do(onSuccess: { covers in
                guard let data = try? JSONEncoder().encode(covers) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.coversKey)
            })
    }
    
    func cachedCovers() -> Single<[TarotCover]> {
        Single<[TarotCover]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.coversKey) else {
                event(.success([]))
                
                return Disposables.create()
            }
            
            let covers = try? JSONDecoder().decode([TarotCover].self, from: data)
            
            event(.success(covers ?? []))
            
            return Disposables.create()
        }
    }
}

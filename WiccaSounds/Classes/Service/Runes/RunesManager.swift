//
//  RunesManager.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import RxSwift

protocol RunesManagerProtocol: Any {
    func obtainCovers(forceUpdate: Bool) -> Single<[RuneCover]>
    func obtaitRune(id: Int) -> Single<Rune?>
}

final class RunesManager {
    enum Constants {
        static let coversKey = "runes_manager_covers_key"
    }
    
    private lazy var sessionManager = SessionManager()
    
    private lazy var defaultWrapper = DefaultRequestWrapper()
}

// MARK: RunesManagerProtocol
extension RunesManager: RunesManagerProtocol {
    func obtainCovers(forceUpdate: Bool) -> Single<[RuneCover]> {
        forceUpdate ? loadCovers() : cachedCovers()
    }
    
    func obtaitRune(id: Int) -> Single<Rune?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetRuneRequest(
            userToken: userToken,
            runeId: id
        )
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .map { GetRuneResponse.map(from: $0) }
    }
}

// MARK: Private
private extension RunesManager {
    func loadCovers() -> Single<[RuneCover]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetRunesCoversRequest(userToken: userToken)
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .map { GetRunesCoversResponse.map(from: $0) }
            .do(onSuccess: { covers in
                guard let data = try? JSONEncoder().encode(covers) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.coversKey)
            })
    }
    
    func cachedCovers() -> Single<[RuneCover]> {
        Single<[RuneCover]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.coversKey) else {
                event(.success([]))
                
                return Disposables.create()
            }
            
            let covers = try? JSONDecoder().decode([RuneCover].self, from: data)
            
            event(.success(covers ?? []))
            
            return Disposables.create()
        }
    }
}

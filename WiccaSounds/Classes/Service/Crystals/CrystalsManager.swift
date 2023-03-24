//
//  CrystalsManager.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import RxSwift

protocol CrystalsManagerProtocol {
    func obtainCrystals(forceUpdate: Bool) -> Single<[Crystal]>
    func save(crystalId: Int) -> Single<Void>
    func unsave(crystalId: Int) -> Single<Void>
}

final class CrystalsManager {
    enum Constants {
        static let crystalsKey = "crystals_manager_crystals_key"
    }
    
    private lazy var sessionManager = SessionManager()
    
    private lazy var defaultWrapper = DefaultRequestWrapper()
}

// MARK: CrystalsManagerProtocol
extension CrystalsManager: CrystalsManagerProtocol {
    func obtainCrystals(forceUpdate: Bool) -> Single<[Crystal]> {
        forceUpdate ? loadCrystals() : cachedCrystals()
    }
    
    func save(crystalId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SaveCrystalRequest(
            userToken: userToken,
            crystalId: crystalId
        )
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: { [weak self] in
                self?.replace(id: crystalId, saved: true)
                CrystalsMediator.shared.didSave(crystalId: crystalId)
            })
    }
    
    func unsave(crystalId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = UnsaveCrystalRequest(
            userToken: userToken,
            crystalId: crystalId
        )
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: { [weak self] in
                self?.replace(id: crystalId, saved: false)
                CrystalsMediator.shared.didUnsave(crystalId: crystalId)
            })
    }
}

// MARK: Private
private extension CrystalsManager {
    func loadCrystals() -> Single<[Crystal]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetCrystalsRequest(userToken: userToken)
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .map { GetCrystalsResponse.map(from: $0) }
            .do(onSuccess: { crystals in
                guard let data = try? JSONEncoder().encode(crystals) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.crystalsKey)
            })
    }
    
    func cachedCrystals() -> Single<[Crystal]> {
        Single<[Crystal]>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.crystalsKey),
                let crystals = try? JSONDecoder().decode([Crystal].self, from: data)
            else {
                event(.success([]))
                return Disposables.create()
            }
            
            event(.success(crystals))
            
            return Disposables.create()
        }
    }
    
    func replace(id: Int, saved: Bool) {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.crystalsKey),
            var crystals = try? JSONDecoder().decode([Crystal].self, from: data)
        else {
            return
        }
        
        if let index = crystals.firstIndex(where: { $0.id == id }) {
            let crystal = crystals[index]
            
            let new = Crystal(
                id: crystal.id,
                name: crystal.name,
                image: crystal.image,
                blocks: crystal.blocks,
                saved: saved,
                paid: crystal.paid
            )
            
            crystals[index] = new
            
            if let data = try? JSONEncoder().encode(crystals) {
                UserDefaults.standard.set(data, forKey: Constants.crystalsKey)
            }
        }
    }
}

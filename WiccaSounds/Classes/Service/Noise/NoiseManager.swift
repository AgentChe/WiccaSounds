//
//  NoiseManager.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.04.2023.
//

import RxSwift

protocol NoiseManagerProtocol: AnyObject {
    func obtainNoiseCategories(forceUpdate: Bool) -> Single<[NoiseCategory]>
}

final class NoiseManager {
    enum Constants {
        static let noiseCategoriesKey = "noise_manager_noise_categories_key"
    }
    
    private lazy var sessionManager = SessionManager()
    
    private lazy var defaultWrapper = DefaultRequestWrapper()
}

// MARK: NoiseManagerProtocol
extension NoiseManager: NoiseManagerProtocol {
    func obtainNoiseCategories(forceUpdate: Bool) -> Single<[NoiseCategory]> {
        forceUpdate ? loadNoiseCategoies() : cachedNoiseCategories()
    }
}

// MARK: Private
private extension NoiseManager {
    func loadNoiseCategoies() -> Single<[NoiseCategory]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetNoiseCategoriesRequest(userToken: userToken)
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .map { GetNoiseCategoriesResponse.map(from: $0) }
            .do(onSuccess: { categories in
                guard let data = try? JSONEncoder().encode(categories) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.noiseCategoriesKey)
            })
    }
    
    func cachedNoiseCategories() -> Single<[NoiseCategory]> {
        Single<[NoiseCategory]>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.noiseCategoriesKey),
                let categories = try? JSONDecoder().decode([NoiseCategory].self, from: data)
            else {
                event(.success([]))
                return Disposables.create()
            }
            
            event(.success(categories))
            
            return Disposables.create()
        }
    }
}

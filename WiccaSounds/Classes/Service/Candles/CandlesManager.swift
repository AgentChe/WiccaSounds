//
//  CandlesManager.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import RxSwift

protocol CandlesManagerProtocol {
    func obtainCandles(forceUpdate: Bool) -> Single<[Candle]>
    func save(candleId: Int) -> Single<Void>
    func unsave(candleId: Int) -> Single<Void>
}

final class CandlesManager {
    enum Constants {
        static let candlesKey = "candles_manager_candles_key"
    }
    
    private lazy var sessionManager = SessionManager()
    
    private lazy var defaultWrapper = DefaultRequestWrapper()
}

// MARK: CandlesManagerProtocol
extension CandlesManager: CandlesManagerProtocol {
    func obtainCandles(forceUpdate: Bool) -> Single<[Candle]> {
        forceUpdate ? loadCandles() : cachedCandles()
    }
    
    func save(candleId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = SaveCandleRequest(
            userToken: userToken,
            candleId: candleId
        )
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: { [weak self] in
                self?.replace(id: candleId, saved: true)
                CandlesMediator.shared.didSave(candleId: candleId)
            })
    }
    
    func unsave(candleId: Int) -> Single<Void> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = UnsaveCandleRequest(
            userToken: userToken,
            candleId: candleId
        )
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .mapToVoid()
            .do(onSuccess: { [weak self] in
                self?.replace(id: candleId, saved: false)
                CandlesMediator.shared.didUnsave(candleId: candleId)
            })
    }
}

// MARK: Private
private extension CandlesManager {
    func loadCandles() -> Single<[Candle]> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetCandlesRequest(userToken: userToken)
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .map { GetCandlesResponse.map(from: $0) }
            .do(onSuccess: { candles in
                guard let data = try? JSONEncoder().encode(candles) else {
                    return
                }
                
                UserDefaults.standard.set(data, forKey: Constants.candlesKey)
            })
    }
    
    func cachedCandles() -> Single<[Candle]> {
        Single<[Candle]>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.candlesKey),
                let candles = try? JSONDecoder().decode([Candle].self, from: data)
            else {
                event(.success([]))
                return Disposables.create()
            }
            
            event(.success(candles))
            
            return Disposables.create()
        }
    }
    
    func replace(id: Int, saved: Bool) {
        guard
            let data = UserDefaults.standard.data(forKey: Constants.candlesKey),
            var candles = try? JSONDecoder().decode([Candle].self, from: data)
        else {
            return
        }
        
        if let index = candles.firstIndex(where: { $0.id == id }) {
            let candle = candles[index]
            
            let new = Candle(
                id: candle.id,
                name: candle.name,
                image: candle.image,
                blocks: candle.blocks,
                saved: saved,
                paid: candle.paid
            )
            
            candles[index] = new
            
            if let data = try? JSONEncoder().encode(candles) {
                UserDefaults.standard.set(data, forKey: Constants.candlesKey)
            }
        }
    }
}

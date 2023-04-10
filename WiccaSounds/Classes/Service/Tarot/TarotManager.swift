//
//  TarotManager.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import RxSwift

protocol TarotManagerProtocol: Any {
    func obtainCovers(forceUpdate: Bool) -> Single<[TarotCover]>
    func obtainTarot(id: Int) -> Single<Tarot?>
    func obtainTarotOnToday() -> Single<TarotOnDay?>
    func set(tarotOnToday: TarotOnDay) -> Single<Void>
}

final class TarotManager {
    enum Constants {
        static let coversKey = "tarot_manager_covers_key"
        static let tarotOnTodayKey = "tarot_manager_tarot_on_today_key"
    }
    
    private lazy var sessionManager = SessionManager()
    
    private lazy var defaultWrapper = DefaultRequestWrapper()
}

// MARK: TarotManagerProtocol
extension TarotManager: TarotManagerProtocol {
    func obtainCovers(forceUpdate: Bool) -> Single<[TarotCover]> {
        forceUpdate ? loadCovers() : cachedCovers()
    }
    
    func obtainTarot(id: Int) -> Single<Tarot?> {
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
    
    func obtainTarotOnToday() -> Single<TarotOnDay?> {
        Single<TarotOnDay?>.create { event in
            guard
                let data = UserDefaults.standard.data(forKey: Constants.tarotOnTodayKey),
                let tarotOnDay = try? JSONDecoder().decode(TarotOnDay.self, from: data)
            else {
                event(.success(nil))
                return Disposables.create()
            }
            
            let onToday = Calendar.current.isDateInToday(tarotOnDay.onDay)
            let tarot: TarotOnDay? = onToday ? tarotOnDay : nil
            
            event(.success(tarot))
            
            return Disposables.create()
        }
    }
    
    func set(tarotOnToday: TarotOnDay) -> Single<Void> {
        Single<Void>.create { event in
            guard let data = try? JSONEncoder().encode(tarotOnToday) else {
                event(.success(Void()))
                
                return Disposables.create()
            }
            
            UserDefaults.standard.set(data, forKey: Constants.tarotOnTodayKey)
            
            event(.success(Void()))
            
            return Disposables.create()
        }
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

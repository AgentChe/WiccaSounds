//
//  ContentManager.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import RxSwift

protocol ContentManagerProtocol: Any {
    func obtainHomeKit() -> Single<HomeKit?>
    func obtainStory(id: Int) -> Single<Story?>
}

final class ContentManager {
    private lazy var sessionManager = SessionManager()
    
    private lazy var defaultWrapper = DefaultRequestWrapper()
}

// MARK: ContentManagerProtocol
extension ContentManager: ContentManagerProtocol {
    func obtainHomeKit() -> Single<HomeKit?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetHomeKitRequest(userToken: userToken)
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .map { GetHomeKitResponse.map(from: $0) }
    }
    
    func obtainStory(id: Int) -> Single<Story?> {
        guard let userToken = sessionManager.getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetStoryRequest(
            userToken: userToken,
            storyId: id
        )
        
        return defaultWrapper
            .callServerApi(requestBody: request)
            .map { GetStoryResponse.map(from: $0) }
    }
}

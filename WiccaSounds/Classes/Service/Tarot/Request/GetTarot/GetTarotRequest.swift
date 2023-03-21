//
//  GetTarotRequest.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Alamofire

struct GetTarotRequest: APIRequestBody {
    let userToken: String
    let tarotId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/tarot/show"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "tarot_id": tarotId
        ]
    }
}

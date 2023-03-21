//
//  GetTarotCoversRequest.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Alamofire

struct GetTarotCoversRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/tarot/list"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
    }
}

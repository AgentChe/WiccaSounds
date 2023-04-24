//
//  GetNoiseCategoriesRequest.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.04.2023.
//

import Alamofire

struct GetNoiseCategoriesRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/sounds/content"
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

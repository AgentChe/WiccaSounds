//
//  UnsaveHerbRequest.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Alamofire

struct UnsaveHerbRequest: APIRequestBody {
    let userToken: String
    let herbId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/herbs/unsave"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "herb_id": herbId
        ]
    }
}

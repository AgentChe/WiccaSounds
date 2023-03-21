//
//  GetRunesCoversRequest.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Alamofire

struct GetRunesCoversRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/runes/list"
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

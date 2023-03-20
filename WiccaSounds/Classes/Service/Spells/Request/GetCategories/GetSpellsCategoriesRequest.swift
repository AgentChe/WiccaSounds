//
//  GetSpellsCategoriesRequest.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.03.2023.
//

import Alamofire

struct GetSpellsCategoriesRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domain + "/api/spells/categories"
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

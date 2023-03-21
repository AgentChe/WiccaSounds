//
//  GetRuneRequest.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Alamofire

struct GetRuneRequest: APIRequestBody {
    let userToken: String
    let runeId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/runes/show"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "rune_id": runeId
        ]
    }
}

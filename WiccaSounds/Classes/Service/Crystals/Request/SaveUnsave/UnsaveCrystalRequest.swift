//
//  UnsaveCrystalRequest.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Alamofire

struct UnsaveCrystalRequest: APIRequestBody {
    let userToken: String
    let crystalId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/crystals/unsave"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "crystal_id": crystalId
        ]
    }
}

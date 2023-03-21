//
//  SaveSpellRequest.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Alamofire

struct SaveSpellRequest: APIRequestBody {
    let userToken: String
    let spellId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/spells/save"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "spell_id": spellId
        ]
    }
}

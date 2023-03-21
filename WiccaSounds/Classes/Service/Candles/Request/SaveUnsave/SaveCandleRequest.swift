//
//  SaveCandleRequest.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Alamofire

struct SaveCandleRequest: APIRequestBody {
    let userToken: String
    let candleId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/candles/save"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "candle_id": candleId
        ]
    }
}

//
//  GetStoryRequest.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Alamofire

struct GetStoryRequest: APIRequestBody {
    let userToken: String
    let storyId: Int
    
    var url: String {
        GlobalDefinitions.domain + "/api/stories/show"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "story_id": storyId
        ]
    }
}

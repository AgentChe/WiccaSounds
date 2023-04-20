//
//  GetPaygateResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 27.12.2022.
//

import UIKit

final class GetPaygateResponse {
    static func map(from response: Any) throws -> Paygate? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let options = data["options"] as? [[String: Any]],
            let optionTopJSON = options.first,
            let topConfig = map(optionJSON: optionTopJSON),
            let optionBottomJSON = options.last,
            let bottomConfig = map(optionJSON: optionBottomJSON)
        else {
            return nil
        }
        
        return Paygate(topOptionConfig: topConfig,
                       bottomOptionConfig: bottomConfig)
    }
}

// MARK: Private
private extension GetPaygateResponse {
    static func map(optionJSON: [String: Any]) -> PaygateOptionConfig? {
        guard
            let productId = optionJSON["product_id"] as? String,
            let title = optionJSON["title"] as? String,
            let caption = optionJSON["caption"] as? String
        else {
            return nil
        }
        
        let div = optionJSON["div"] as? Int
        let save = optionJSON["save"] as? String
        
        return PaygateOptionConfig(
            productId: productId,
            title: title,
            caption: caption,
            div: div,
            save: save
        )
    }
}

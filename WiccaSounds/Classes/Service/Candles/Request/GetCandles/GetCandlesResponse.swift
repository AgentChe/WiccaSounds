//
//  GetCandlesResponse.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

enum GetCandlesResponse {
    static func map(from response: Any) -> [Candle] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let array = data["candles"] as? [[String: Any]]
        else {
            return []
        }
        
        return array.compactMap { candleJSON -> Candle? in
            guard
                let id = candleJSON["candle_id"] as? Int,
                let name = candleJSON["name"] as? String,
                let imagePath = candleJSON["image"] as? String,
                let imageUrl = URL(string: imagePath),
                let blocksArray = candleJSON["blocks"] as? [[String: Any]],
                let saved = candleJSON["saved"] as? Bool,
                let paid = candleJSON["paid"] as? Bool
            else {
                return nil
            }
            
            let blocks = blocksArray.compactMap { ContentBlockMapper.map(from: $0) }
            
            return Candle(
                id: id,
                name: name,
                image: imageUrl,
                blocks: blocks,
                saved: saved,
                paid: paid
            )
        }
    }
}

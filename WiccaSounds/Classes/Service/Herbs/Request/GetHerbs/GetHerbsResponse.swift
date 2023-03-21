//
//  GetHerbsResponse.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

enum GetHerbsResponse {
    static func map(from response: Any) -> [Herb] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let array = data["herbs"] as? [[String: Any]]
        else {
            return []
        }
        
        return array.compactMap { herbJSON -> Herb? in
            guard
                let id = herbJSON["herb_id"] as? Int,
                let name = herbJSON["name"] as? String,
                let imagePath = herbJSON["image"] as? String,
                let imageUrl = URL(string: imagePath),
                let blocksArray = herbJSON["blocks"] as? [[String: Any]],
                let saved = herbJSON["saved"] as? Bool,
                let paid = herbJSON["paid"] as? Bool
            else {
                return nil
            }
            
            let blocks = blocksArray.compactMap { ContentBlockMapper.map(from: $0) }
            
            return Herb(
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

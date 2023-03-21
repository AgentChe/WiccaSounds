//
//  GetCrystalsResponse.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

enum GetCrystalsResponse {
    static func map(from response: Any) -> [Crystal] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let array = data["crystals"] as? [[String: Any]]
        else {
            return []
        }
        
        return array.compactMap { crystalJSON -> Crystal? in
            guard
                let id = crystalJSON["crystal_id"] as? Int,
                let name = crystalJSON["name"] as? String,
                let imagePath = crystalJSON["image"] as? String,
                let imageUrl = URL(string: imagePath),
                let blocksArray = crystalJSON["blocks"] as? [[String: Any]],
                let saved = crystalJSON["saved"] as? Bool,
                let paid = crystalJSON["paid"] as? Bool
            else {
                return nil
            }
            
            let blocks = blocksArray.compactMap { ContentBlockMapper.map(from: $0) }
            
            return Crystal(
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

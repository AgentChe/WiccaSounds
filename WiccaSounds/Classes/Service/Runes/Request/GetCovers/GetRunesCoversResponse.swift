//
//  GetRunesCoversResponse.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

enum GetRunesCoversResponse {
    static func map(from response: Any) -> [RuneCover] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let array = data["runes"] as? [[String: Any]]
        else {
            return []
        }
        
        return array.compactMap { json -> RuneCover? in
            guard
                let id = json["rune_id"] as? Int,
                let name = json["name"] as? String,
                let imagePath = json["image"] as? String,
                let imageUrl = URL(string: imagePath),
                let paid = json["paid"] as? Bool
            else {
                return nil
            }
            
            return RuneCover(
                id: id,
                name: name,
                image: imageUrl,
                paid: paid
            )
        }
    }
}

//
//  GetRuneResponse.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

enum GetRuneResponse {
    static func map(from respone: Any) -> Rune? {
        guard
            let json = respone as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let id = data["rune_id"] as? Int,
            let name = data["name"] as? String,
            let imagePath = data["image"] as? String,
            let imageUrl = URL(string: imagePath),
            let blocksArray = data["blocks"] as? [[String: Any]]
        else {
            return nil
        }
        
        let blocks = blocksArray.compactMap { ContentBlockMapper.map(from: $0) }
        
        return Rune(
            id: id,
            name: name,
            image: imageUrl,
            blocks: blocks
        )
    }
}

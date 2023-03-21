//
//  GetTarotResponse.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

enum GetTarotResponse {
    static func map(from response: Any) -> Tarot? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let id = data["tarot_id"] as? Int,
            let name = data["name"] as? String,
            let imagePath = data["image"] as? String,
            let imageUrl = URL(string: imagePath),
            let meaningJSON = data["meaning"] as? [String: Any],
            let uprightJSON = meaningJSON["upright"] as? [String: Any],
            let reversedJSON = meaningJSON["reversed"] as? [String: Any]
        else {
            return nil
        }
        
        let upright = Self.meaning(from: uprightJSON)
        let reversed = Self.meaning(from: reversedJSON)
        
        return Tarot(
            id: id,
            name: name,
            image: imageUrl,
            upright: upright,
            reversed: reversed
        )
    }
}

// MARK: Private
private extension GetTarotResponse {
    static func meaning(from json: [String: Any]) -> TarotMeaning {
        let contentArray = json["content"] as? [[String: Any]] ?? []
        let tags = json["tags"] as? [String] ?? []
        
        let sections = contentArray.compactMap { contentJSON -> TarotContentSection? in
            guard
                let section = contentJSON["section"] as? String,
                let blocksArray = contentJSON["blocks"] as? [[String: Any]]
            else {
                return nil
            }
            
            let blocks = blocksArray.compactMap { ContentBlockMapper.map(from: $0) }
            
            return TarotContentSection(
                section: section,
                blocks: blocks
            )
        }
        
        return TarotMeaning(
            sections: sections,
            tags: tags
        )
    }
}

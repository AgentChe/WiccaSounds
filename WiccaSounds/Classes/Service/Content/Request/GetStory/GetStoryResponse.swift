//
//  GetStoryResponse.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

enum GetStoryResponse {
    static func map(from response: Any) -> Story? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let id = data["story_id"] as? Int,
            let name = data["name"] as? String,
            let color = data["color"] as? String,
            let cardsArray = data["cards"] as? [[String: Any]]
        else {
            return nil
        }
        
        let cards = cardsArray.compactMap { json -> StoryCard? in
            guard
                let id = json["card_id"] as? Int,
                let title = json["title"] as? String,
                let blocksArray = json["blocks"] as? [[String: Any]]
            else {
                return nil
            }
            
            let blocks = blocksArray.compactMap { ContentBlockMapper.map(from: $0) }
            
            return StoryCard(
                id: id,
                title: title,
                blocks: blocks
            )
        }
        
        return Story(
            id: id,
            name: name,
            colorHex: color,
            cards: cards
        )
    }
}

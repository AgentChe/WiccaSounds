//
//  GetSpellsResponse.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

enum GetSpellsResponse {
    static func map(from response: Any) -> [Spell] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let array = data["categories"] as? [[String: Any]]
        else {
            return []
        }
        
        return array.reduce([]) { result, json -> [Spell] in
            guard
                let categoryId = json["category_id"] as? Int,
                let spellsArray = json["spells"] as? [[String: Any]]
            else {
                return result
            }
            
            let spells = spellsArray.compactMap { spellJSON -> Spell? in
                guard
                    let id = spellJSON["spell_id"] as? Int,
                    let name = spellJSON["name"] as? String,
                    let blocksArray = spellJSON["blocks"] as? [[String: Any]],
                    let saved = spellJSON["saved"] as? Bool,
                    let paid = spellJSON["paid"] as? Bool
                else {
                    return nil
                }
                
                let blocks = blocksArray.compactMap { ContentBlockMapper.map(from: $0) }
                
                return Spell(
                    id: id,
                    name: name,
                    categoryId: categoryId,
                    blocks: blocks,
                    saved: saved,
                    paid: paid
                )
            }
            
            return result + spells
        }
    }
}

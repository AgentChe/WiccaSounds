//
//  GetSpellsCategoriesResponse.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.03.2023.
//

import Foundation

enum GetSpellsCategoriesResponse {
    static func map(from response: Any) -> [SpellsCategory] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let array = data["categories"] as? [[String: Any]]
        else {
            return []
        }
        
        return array.compactMap { categoryJSON -> SpellsCategory? in
            guard
                let id = categoryJSON["category_id"] as? Int,
                let name = categoryJSON["name"] as? String
            else {
                return nil
            }
            
            return SpellsCategory(
                id: id,
                name: name
            )
        }
    }
}

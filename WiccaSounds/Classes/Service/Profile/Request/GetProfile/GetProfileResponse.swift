//
//  GetProfileResponse.swift
//  Soccer
//
//  Created by Андрей Чернышев on 03.02.2023.
//

final class GetProfileResponse {
    static func map(from response: Any) -> Profile? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any]
        else {
            return nil
        }
        
        let spellsCategoriesIds = data["spells_categories_ids"] as? [Int]
        
        return Profile(
            spellsCategoriesIds: spellsCategoriesIds
        )
    }
}

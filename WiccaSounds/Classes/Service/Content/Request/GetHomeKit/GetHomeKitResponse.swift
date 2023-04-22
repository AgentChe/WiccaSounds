//
//  GetHomeKitResponse.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

enum GetHomeKitResponse {
    static func map(from response: Any) -> HomeKit? {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let spellOnDayJSON = data["spell_of_the_day"] as? [String: Any],
            let spellOnDay = Self.spellOnDay(from: spellOnDayJSON),
            let storiesArray = data["stories"] as? [[String: Any]],
            let lunarJSON = data["lunar"] as? [String: Any],
            let lunar = Self.lunar(from: lunarJSON),
            let wheelJSON = data["wheel"] as? [String: Any],
            let wheel = Self.wheel(from: wheelJSON)
        else {
            return nil
        }
        
        let stories = Self.stories(from: storiesArray)
        
        return HomeKit(
            spellOnDay: spellOnDay,
            stories: stories,
            lunar: lunar,
            wheel: wheel
        )
    }
}

// MARK: Private
private extension GetHomeKitResponse {
    static func spellOnDay(from json: [String: Any]) -> Spell? {
        guard
            let id = json["spell_id"] as? Int,
            let name = json["name"] as? String,
            let categoryId = json["category_id"] as? Int,
            let blocksArray = json["blocks"] as? [[String: Any]],
            let saved = json["saved"] as? Bool,
            let paid = json["paid"] as? Bool
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
    
    static func stories(from array: [[String: Any]]) -> [StoryCover] {
        array.compactMap { json -> StoryCover? in
            guard
                let id = json["story_id"] as? Int,
                let name = json["name"] as? String,
                let imagePath = json["image"] as? String,
                let imageUrl = URL(string: imagePath)
            else {
                return nil
            }
            
            return StoryCover(
                id: id,
                name: name,
                image: imageUrl
            )
        }
    }
    
    static func lunar(from json: [String: Any]) -> Lunar? {
        guard
            let phase = json["phase"] as? String,
            let illumination = json["illumination"] as? Int,
            let shadowOffset = json["shadow_offset"] as? Int,
            let daysArray = json["calendar"] as? [[String: Any]],
            let tipsArray = json["tips"] as? [[String: Any]]
        else {
            return nil
        }
        
        let days = daysArray.compactMap { json -> LunarDay? in
            guard
                let date = json["date"] as? String,
                let shadowOffset = json["shadow_offset"] as? Int
            else {
                return nil
            }
            
            return LunarDay(
                date: date,
                shadowOffset: shadowOffset
            )
        }
        
        let tips = tipsArray.compactMap { json -> LunarTip? in
            guard
                let tag = json["tag"] as? String,
                let blocksArray = json["blocks"] as? [[String: Any]],
                let imagePath = json["image_url"] as? String,
                let imageUrl = URL(string: imagePath),
                let paid = json["paid"] as? Bool
            else {
                return nil
            }
            
            let blocks = blocksArray.compactMap { ContentBlockMapper.map(from: $0) }
            
            return LunarTip(
                tag: tag,
                image: imageUrl,
                blocks: blocks,
                paid: paid
            )
        }
        
        return Lunar(
            shadowOffset: shadowOffset,
            phase: phase,
            illumination: illumination,
            days: days,
            tips: tips
        )
    }
    
    static func wheel(from json: [String: Any]) -> WheelOnYear? {
        guard
            let imagePath = json["image"] as? String,
            let imageUrl = URL(string: imagePath),
            let name = json["name"] as? String,
            let blocksArray = json["blocks"] as? [[String: Any]]
        else {
            return nil
        }
        
        let blocks = blocksArray.compactMap { ContentBlockMapper.map(from: $0) }
        
        return WheelOnYear(
            image: imageUrl,
            name: name,
            blocks: blocks
        )
    }
}

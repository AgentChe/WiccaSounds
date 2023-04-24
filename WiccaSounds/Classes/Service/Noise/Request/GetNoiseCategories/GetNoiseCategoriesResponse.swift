//
//  GetNoiseCategoriesResponse.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.04.2023.
//

import Foundation

enum GetNoiseCategoriesResponse {
    static func map(from response: Any) -> [NoiseCategory] {
        guard
            let json = response as? [String: Any],
            let data = json["_data"] as? [String: Any],
            let categoriesArray = data["sound_categories"] as? [[String: Any]]
        else {
            return []
        }
        
        return categoriesArray.enumerated().compactMap { index, json -> NoiseCategory? in
            guard
                let id = json["sound_category_id"] as? Int,
                let name = json["name"] as? String,
                let noisesArray = json["sounds"] as? [[String: Any]]
            else {
                return nil
            }
            
            let noises = noisesArray.enumerated().compactMap { index, json -> Noise? in
                guard
                    let id = json["sound_id"] as? Int,
                    let name = json["name"] as? String,
                    let paid = json["paid"] as? Bool,
                    let noiseCategoryId = json["sound_category_id"] as? Int,
                    let imagePath = json["image_url"] as? String,
                    let imageUrl = URL(string: imagePath),
                    let soundsArray = json["sounds"] as? [[String: Any]]
                else {
                    return nil
                }
                
                let sounds = soundsArray.compactMap { json -> NoiseSound? in
                    guard
                        let id = json["file_id"] as? Int,
                        let soundPath = json["sound_url"] as? String,
                        let soundUrl = URL(string: soundPath),
                        let soundSecs = json["sound_secs"] as? Int
                    else {
                        return nil
                    }
                    
                    return NoiseSound(
                        id: id,
                        soundUrl: soundUrl,
                        soundSecs: soundSecs
                    )
                }
                
                return Noise(
                    id: id,
                    name: name,
                    paid: paid,
                    noiseCategoryId: noiseCategoryId,
                    imageUrl: imageUrl,
                    sounds: sounds,
                    sort: index
                )
            }
            
            return NoiseCategory(
                id: id,
                name: name,
                sort: index,
                noises: noises
            )
        }
    }
}

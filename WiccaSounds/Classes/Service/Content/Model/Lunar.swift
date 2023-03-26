//
//  Lunar.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

struct Lunar: Codable, Hashable {
    let shadowOffset: Int
    let phase: String
    let illumination: Int
    let days: [LunarDay]
    let tips: [LunarTip]
}

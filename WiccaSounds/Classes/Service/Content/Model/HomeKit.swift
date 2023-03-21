//
//  HomeKit.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

struct HomeKit: Codable, Hashable {
    let spellOnDay: Spell
    let stories: [StoryCover]
    let lunar: Lunar
    let wheel: WheelOnYear
}

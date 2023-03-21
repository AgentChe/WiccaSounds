//
//  LunarTip.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

struct LunarTip: Codable, Hashable {
    let tag: String
    let blocks: [ContentBlock]
    let paid: Bool
}

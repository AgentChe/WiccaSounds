//
//  LunarTip.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

struct LunarTip: Codable, Hashable {
    let tag: String
    let image: URL
    let blocks: [ContentBlock]
    let paid: Bool
}

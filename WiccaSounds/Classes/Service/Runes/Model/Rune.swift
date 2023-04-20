//
//  Rune.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

struct Rune: Codable, Hashable {
    let id: Int
    let name: String
    let image: URL
    let blocks: [ContentBlock]
    let tags: [String]
}

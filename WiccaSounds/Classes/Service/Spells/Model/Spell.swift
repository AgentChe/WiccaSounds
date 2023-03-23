//
//  Spell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

struct Spell: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let categoryId: Int
    let blocks: [ContentBlock]
    let saved: Bool
    let paid: Bool
}

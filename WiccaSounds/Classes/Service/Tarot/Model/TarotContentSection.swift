//
//  TarotContentSection.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

struct TarotContentSection: Codable, Hashable {
    let section: String
    let blocks: [ContentBlock]
}

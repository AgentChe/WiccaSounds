//
//  RuneContentSection.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 22.04.2023.
//

struct RuneContentSection: Codable, Hashable {
    let section: String
    let blocks: [ContentBlock]
}

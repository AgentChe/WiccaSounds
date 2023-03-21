//
//  StoryCard.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

struct StoryCard: Codable, Hashable {
    let id: Int
    let title: String?
    let blocks: [ContentBlock]
}

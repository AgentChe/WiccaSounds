//
//  Story.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import UIKit

struct Story: Codable, Hashable {
    let id: Int
    let name: String
    let colorHex: String
    let cards: [StoryCard]
}

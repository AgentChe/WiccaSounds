//
//  Herb.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

struct Herb: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let image: URL
    let blocks: [ContentBlock]
    let saved: Bool
    let paid: Bool
}

//
//  WheelOnYear.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

struct WheelOnYear: Codable, Hashable {
    let image: URL
    let name: String
    let blocks: [ContentBlock]
}

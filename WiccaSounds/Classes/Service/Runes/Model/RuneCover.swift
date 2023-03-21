//
//  RuneCover.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

struct RuneCover: Codable, Hashable {
    let id: Int
    let name: String
    let image: URL
    let paid: Bool
}

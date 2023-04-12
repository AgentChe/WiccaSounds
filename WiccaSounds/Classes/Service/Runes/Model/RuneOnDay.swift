//
//  RuneOnDay.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 10.04.2023.
//

import Foundation

struct RuneOnDay: Codable, Hashable {
    let rune: RuneCover
    let onDay: Date
    let isOpened: Bool
}

//
//  TarotOnDay.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 29.03.2023.
//

import Foundation

struct TarotOnDay: Codable, Hashable {
    let tarot: TarotCover
    let onDay: Date
    let isOpened: Bool
}

//
//  NoiseSound.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.04.2023.
//

import Foundation

struct NoiseSound: Codable, Hashable {
    let id: Int
    let soundUrl: URL
    let soundSecs: Int
}

//
//  Noise.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.04.2023.
//

import Foundation

struct Noise: Codable, Hashable {
    let id: Int
    let name: String
    let paid: Bool
    let noiseCategoryId: Int
    let imageUrl: URL
    let sounds: [NoiseSound]
    let sort: Int
}

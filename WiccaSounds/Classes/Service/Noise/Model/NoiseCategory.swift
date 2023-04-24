//
//  NoiseCategory.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.04.2023.
//

struct NoiseCategory: Codable, Hashable {
    let id: Int
    let name: String
    let sort: Int
    let noises: [Noise]
}

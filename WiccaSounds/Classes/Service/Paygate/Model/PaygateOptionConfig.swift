//
//  PaygateOptionConfig.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.02.2023.
//

struct PaygateOptionConfig: Codable, Hashable {
    let productId: String
    let title: String
    let caption: String
    let div: Int?
    let save: String?
}

//
//  TarotMeaning.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

struct TarotMeaning: Codable, Hashable {
    let sections: [TarotContentSection]
    let tags: [String]
}

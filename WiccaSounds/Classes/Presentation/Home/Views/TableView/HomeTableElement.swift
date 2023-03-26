//
//  HomeTableElement.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.03.2023.
//

struct HomeTableSection {
    let elements: [HomeTableElement]
    let corner: Bool
}

enum HomeTableElement {
    case todayTitle
    case spell(Spell)
    case stories([StoryCover])
    case lunar(Lunar)
}

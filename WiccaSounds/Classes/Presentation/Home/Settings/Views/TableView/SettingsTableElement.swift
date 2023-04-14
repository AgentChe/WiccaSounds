//
//  SettingsTableElement.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 14.04.2023.
//

struct SettingsTableSection {
    let elements: [SettingsTableElement]
    let corner: Bool
    
    init(elements: [SettingsTableElement]) {
        self.elements = elements
        self.corner = true
    }
}

enum SettingsTableElement {
    case favoriteSpells
    case contactUs
    case privacyPolice
    case termsOfUse
}

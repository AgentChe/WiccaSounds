//
//  ExploreTableElement.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 22.03.2023.
//

struct ExploreTableSection {
    let elements: [ExploreTableElement]
}

enum ExploreTableElement {
    case spellsCategory(SpellsCategory)
    case spell(ExploreSpellElement)
    case unit(ExploreUnitElement)
}

struct ExploreSpellElement {
    let spell: Spell
    let locked: Bool
}

struct ExploreUnitElement {
    enum Unit {
        case candle(Candle, locked: Bool)
        case herb(Herb, locked: Bool)
        case crystal(Crystal, locked: Bool)
    }
    
    let unit1: Unit
    let unit2: Unit?
}

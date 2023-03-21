//
//  OSpellsCategoriesTableElement.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.03.2023.
//

final class OSpellsCategoriesTableElement {
    let spellsCategory: SpellsCategory
    var marked: Bool
    
    init(spellsCategory: SpellsCategory, marked: Bool = false) {
        self.spellsCategory = spellsCategory
        self.marked = marked
    }
}

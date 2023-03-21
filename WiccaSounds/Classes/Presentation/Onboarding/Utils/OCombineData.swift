//
//  OCombineData.swift
//  Wicca
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import Foundation

struct OCombineData {
    let spellsCategoriesIds: [Int]
}

final class OnboardingCombineData {
    private var spellsCategories: [SpellsCategory]?
    
    func combineData() -> OCombineData? {
        guard let spellsCategories = spellsCategories else {
            return nil
        }
        
        return OCombineData(spellsCategoriesIds: spellsCategories.map { $0.id })
    }
}

// MARK: OSpellsCategoriesDelegate
extension OnboardingCombineData: OSpellsCategoriesDelegate {
    func onbSpellsCategoriesDidSelect(spellsCategories: [SpellsCategory]) {
        self.spellsCategories = spellsCategories
    }
}

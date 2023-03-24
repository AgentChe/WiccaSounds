//
//  BookmarksViewModel.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.03.2023.
//

import RxSwift
import RxCocoa

final class BookmarksViewModel {
    lazy var didTapFilter = PublishRelay<ExploreFilterView.Filter>()
    
    lazy var sections = makeSections()
    
    private lazy var spellsSections = makeSpellsSections()
    private lazy var spells = makeSpells()
    private lazy var candlesSections = makeCandlesSections()
    private lazy var candles = makeCandles()
    private lazy var herbsSections = makeHerbsSections()
    private lazy var herbs = makeHerbs()
    private lazy var crystalsSections = makeCrystalsSections()
    private lazy var crystals = makeCrystals()
    private lazy var activeSubscription = makeActiveSubscription()
    
    private lazy var spellsManager = SpellsManager()
    private lazy var candlesManager = CandlesManager()
    private lazy var herbsManager = HerbsManager()
    private lazy var crystalsManager = CrystalsManager()
    private lazy var sessionManager = SessionManager()
}

// MARK: Private
private extension BookmarksViewModel {
    enum Action {
        case initial
        case save(Int)
        case unsave(Int)
    }
    
    func makeSections() -> Driver<[ExploreTableSection]> {
        Driver
            .combineLatest(
                didTapFilter.asDriver(onErrorDriveWith: .never()),
                spellsSections,
                candlesSections,
                herbsSections,
                crystalsSections
            )
            .map { filter, spells, candlesSections, herbsSections, crystalsSections -> [ExploreTableSection] in
                switch filter {
                case .spells:
                    return spells
                case .candles:
                    return candlesSections
                case .herbs:
                    return herbsSections
                case .crystals:
                    return crystalsSections
                }
            }
    }
    
    func makeSpellsSections() -> Driver<[ExploreTableSection]> {
        Driver
            .combineLatest(
                spells,
                activeSubscription
            )
            .map { spells, activeSubscription -> [ExploreTableSection] in
                spells.map { spell -> ExploreTableSection in
                    let element = ExploreSpellElement(
                        spell: spell,
                        locked: spell.paid ? !activeSubscription : false
                    )
                    return ExploreTableSection(elements: [.spell(element)])
                }
            }
    }
    
    func makeSpells() -> Driver<[Spell]> {
        let spells = spellsManager
            .obtainSpells(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
            .map { spells -> [Spell] in
                spells.filter { $0.saved }
            }
        
        return makeUnits(
            units: spells,
            saveTrigger: SpellsMediator.shared.didSaveSpell,
            unsaveTrigger: SpellsMediator.shared.didUnsaveSpell,
            recreate: { spell, saved -> Spell in
                Spell(
                    id: spell.id,
                    name: spell.name,
                    categoryId: spell.categoryId,
                    blocks: spell.blocks,
                    saved: saved,
                    paid: spell.paid
                )
            }
        )
    }
    
    func makeSpellsCategories() -> Driver<[SpellsCategory]> {
        spellsManager
            .obtainCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeCandlesSections() -> Driver<[ExploreTableSection]> {
        Driver
            .combineLatest(
                candles,
                activeSubscription
            )
            .map { [weak self] candles, activeSubscription -> [ExploreTableSection] in
                guard let self = self else {
                    return []
                }
                
                return self.unitsSections(array: candles) {
                    .candle($0, locked: $0.paid ? !activeSubscription : false)
                }
            }
    }
    
    func makeCandles() -> Driver<[Candle]> {
        let candles = candlesManager
            .obtainCandles(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
            .map { candles -> [Candle] in
                candles.filter { $0.saved }
            }
        
        return makeUnits(
            units: candles,
            saveTrigger: CandlesMediator.shared.didSaveCandle,
            unsaveTrigger: CandlesMediator.shared.didUnsaveCandle,
            recreate: { candle, saved -> Candle in
                Candle(
                    id: candle.id,
                    name: candle.name,
                    image: candle.image,
                    blocks: candle.blocks,
                    saved: saved,
                    paid: candle.paid
                )
            }
        )
    }
    
    func makeHerbsSections() -> Driver<[ExploreTableSection]> {
        Driver
            .combineLatest(
                herbs,
                activeSubscription
            )
            .map { [weak self] herbs, activeSubscription -> [ExploreTableSection] in
                guard let self = self else {
                    return []
                }
                
                return self.unitsSections(array: herbs) {
                    .herb($0, locked: $0.paid ? !activeSubscription : false)
                }
            }
    }
    
    func makeHerbs() -> Driver<[Herb]> {
        let herbs = herbsManager
            .obtainHerbs(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
            .map { herbs -> [Herb] in
                herbs.filter { $0.saved }
            }
        
        return makeUnits(
            units: herbs,
            saveTrigger: HerbsMediator.shared.didSaveHerb,
            unsaveTrigger: HerbsMediator.shared.didUnsaveHerb,
            recreate: { herb, saved -> Herb in
                Herb(
                    id: herb.id,
                    name: herb.name,
                    image: herb.image,
                    blocks: herb.blocks,
                    saved: saved,
                    paid: herb.paid
                )
            }
        )
    }
    
    func makeCrystalsSections() -> Driver<[ExploreTableSection]> {
        Driver
            .combineLatest(
                crystals,
                activeSubscription
            )
            .map { [weak self] crystals, activeSubscription -> [ExploreTableSection] in
                guard let self = self else {
                    return []
                }
                
                return self.unitsSections(array: crystals) {
                    .crystal($0, locked: $0.paid ? !activeSubscription : false)
                }
            }
    }
    
    func makeCrystals() -> Driver<[Crystal]> {
        let crystals = crystalsManager
            .obtainCrystals(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
            .map { crystals -> [Crystal] in
                crystals.filter { $0.saved }
            }
        
        return makeUnits(
            units: crystals,
            saveTrigger: CrystalsMediator.shared.didSaveCrystal,
            unsaveTrigger: CrystalsMediator.shared.didUnsaveCrystal,
            recreate: { crystal, saved -> Crystal in
                Crystal(
                    id: crystal.id,
                    name: crystal.name,
                    image: crystal.image,
                    blocks: crystal.blocks,
                    saved: saved,
                    paid: crystal.paid
                )
            }
        )
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { [weak self] in
                guard let self = self else {
                    return false
                }
                
                return self.sessionManager.hasActiveSubscriptions()
            }
            .startWith(sessionManager.hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
    }
}

// MARK: Private (Additional)
private extension BookmarksViewModel {
    func unitsSections<T>(array: [T], createUnit: (T) -> ExploreUnitElement.Unit) -> [ExploreTableSection] {
        var elements: [ExploreTableElement] = []
        
        var previousUnit: ExploreUnitElement.Unit?
        
        let count = array.count
        
        array.enumerated().forEach { index, item in
            let unit = createUnit(item)
            
            if let unit1 = previousUnit {
                let unitElement = ExploreUnitElement(
                    unit1: unit1,
                    unit2: unit
                )
                elements.append(.unit(unitElement))
                
                previousUnit = nil
            } else if (count - 1) == index {
                let unitElement = ExploreUnitElement(
                    unit1: unit,
                    unit2: nil
                )
                elements.append(.unit(unitElement))
            } else {
                previousUnit = unit
            }
        }
        
        return [
            ExploreTableSection(elements: elements)
        ]
    }
    
    func makeUnits<T: Identifiable<Int>>(
        units: Driver<[T]>,
        saveTrigger: Signal<Int>,
        unsaveTrigger: Signal<Int>,
        recreate: @escaping (T, Bool) -> T
    ) -> Driver<[T]> {
        units
            .flatMapLatest { units -> Driver<[T]> in
                let save = saveTrigger
                    .map { Action.save($0) }
                    .asDriver(onErrorDriveWith: .never())
                let unsave = unsaveTrigger
                    .map { Action.unsave($0) }
                    .asDriver(onErrorDriveWith: .never())
                
                return Driver
                    .merge(save, unsave)
                    .startWith(.initial)
                    .scan(units) { units, action -> [T] in
                        switch action {
                        case .initial:
                            return units
                        case .save(let id):
                            var copy = units
                            
                            if let index = copy.firstIndex(where: { $0.id == id }) {
                                let unit = copy[index]
                                let new = recreate(unit, true)
                                copy[index] = new
                            }
                            
                            return copy
                        case .unsave(let id):
                            var copy = units
                            
                            if let index = copy.firstIndex(where: { $0.id == id }) {
                                copy.remove(at: index)
                            }
                            
                            return copy
                        }
                    }
            }
    }
}

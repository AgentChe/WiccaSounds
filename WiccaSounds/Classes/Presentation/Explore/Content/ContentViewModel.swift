//
//  ContentViewModel.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 23.03.2023.
//

import RxSwift
import RxCocoa

final class ContentViewModel {
    enum Unit {
        case spell(Spell)
        case candle(Candle)
        case herb(Herb)
        case crystal(Crystal)
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didTapBookmark = PublishRelay<Bool>()
    
    lazy var isSaved = makeIsSaved()
    lazy var elements = makeElements()
    
    private let source: Driver<Unit>
    
    private lazy var spellsManager = SpellsManager()
    private lazy var candleManager = CandlesManager()
    private lazy var herbsManager = HerbsManager()
    private lazy var crystalsManager = CrystalsManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(source: Unit) {
        self.source = BehaviorRelay(value: source).asDriver()
    }
}

// MARK: Private
private extension ContentViewModel {
    func makeIsSaved() -> Driver<Bool> {
        let initial = source
            .map { $0.saved }
        
        let action = didTapBookmark
            .withLatestFrom(source) { ($0, $1) }
            .flatMapFirst { [weak self] saved, unit -> Observable<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Bool> {
                    let request: Single<Void>
                    switch unit {
                    case .spell(let spell):
                        request = saved ? self.spellsManager.unsave(spellId: spell.id) : self.spellsManager.save(spellId: spell.id)
                    case .candle(let candle):
                        request = saved ? self.candleManager.unsave(candleId: candle.id) : self.candleManager.save(candleId: candle.id)
                    case .herb(let herb):
                        request = saved ? self.herbsManager.unsave(herbId: herb.id) : self.herbsManager.save(herbId: herb.id)
                    case .crystal(let crystal):
                        request = saved ? self.crystalsManager.unsave(crystalId: crystal.id) : self.crystalsManager.save(crystalId: crystal.id)
                    }
                    
                    return request
                        .map { !saved }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }

                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(initial, action)
    }
    
    func makeElements() -> Driver<[ContentTableElement]> {
        source
            .map { source -> [ContentTableElement] in
                let blocksElements = source.blocks.map { block -> ContentTableElement in
                    switch block.content {
                    case .image(let url):
                        return .image(url)
                    case .text(let text):
                        return .text(text)
                    }
                }
                
                return [.title(source.title)] + blocksElements
            }
    }
}

// MARK: Private (Additional)
private extension ContentViewModel.Unit {
    var title: String {
        switch self {
        case .spell(let spell):
            return spell.name
        case .candle(let candle):
            return candle.name
        case .herb(let herb):
            return herb.name
        case .crystal(let crystal):
            return crystal.name
        }
    }
    
    var blocks: [ContentBlock] {
        switch self {
        case .spell(let spell):
            return spell.blocks
        case .candle(let candle):
            return candle.blocks
        case .herb(let herb):
            return herb.blocks
        case .crystal(let crystal):
            return crystal.blocks
        }
    }
    
    var saved: Bool {
        switch self {
        case .spell(let spell):
            return spell.saved
        case .candle(let candle):
            return candle.saved
        case .herb(let herb):
            return herb.saved
        case .crystal(let crystal):
            return crystal.saved
        }
    }
}

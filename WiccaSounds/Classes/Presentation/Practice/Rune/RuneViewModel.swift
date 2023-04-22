//
//  RuneViewModel.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import RxSwift
import RxCocoa

final class RuneViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var rune = makeRune()
    private let runeId: Driver<Int>
    
    private lazy var runesManager = RunesManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(id: Int) {
        runeId = BehaviorRelay(value: id).asDriver()
    }
}

// MARK: Private
private extension RuneViewModel {
    func makeElements() -> Driver<[RuneTableElement]> {
        rune
            .map { rune -> [RuneTableElement] in
                var elements: [RuneTableElement] = [
                    .name(rune.name),
                    .image(rune.image)
                ]
                
                if !rune.tags.isEmpty {
                    elements.append(contentsOf: [
                        .title("Rune.StandsFor".localized),
                        .tags(rune.tags)
                    ])
                }
                
                if !rune.blocks.isEmpty {
                    elements.append(.title("Rune.Meaning".localized))
                    
                    rune.blocks.forEach { block in
                        switch block.content {
                        case .text(let text):
                            elements.append(.text(text))
                        case .image(let image):
                            elements.append(.contentImage(image))
                        }
                    }
                }
                
                if let sound = rune.sound {
                    elements.append(contentsOf: [
                        .title("Rune.Sound".localized),
                        .text(sound)
                    ])
                }
                
                if let element = rune.elements {
                    elements.append(contentsOf: [
                        .title("Rune.Elements".localized),
                        .text(element)
                    ])
                }
                
                if let color = rune.color {
                    elements.append(contentsOf: [
                        .title("Rune.Color".localized),
                        .text(color)
                    ])
                }
                
                return elements
            }
    }
    
    func makeRune() -> Driver<Rune> {
        runeId
            .flatMapLatest { [weak self] id -> Driver<Rune> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Rune> {
                    self.runesManager
                        .obtainRune(id: id)
                        .flatMap { rune -> Single<Rune> in
                            guard let rune = rune else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(rune)
                        }
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
                    .trackActivity(self.activity)
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}

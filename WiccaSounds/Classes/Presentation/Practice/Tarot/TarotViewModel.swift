//
//  TarotViewModel.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import RxSwift
import RxCocoa

final class TarotViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didSelectMode = PublishRelay<TarotModeCell.Mode>()
    
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var tarot = makeTarot()
    private let tarotId: Driver<Int>
    
    private lazy var tarotManager = TarotManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(id: Int) {
        tarotId = BehaviorRelay(value: id).asDriver()
    }
}

// MARK: Private
private extension TarotViewModel {
    func makeElements() -> Driver<[TarotTableElement]> {
        Driver
            .combineLatest(
                tarot,
                didSelectMode
                    .startWith(.upright)
                    .asDriver(onErrorDriveWith: .never())
            )
            .map { tarot, mode -> [TarotTableElement] in
                let meaning: TarotMeaning
                switch mode {
                case .upright:
                    meaning = tarot.upright
                case .reversed:
                    meaning = tarot.reversed
                }
                
                var elements: [TarotTableElement] = [
                    .name(tarot.name),
                    .mode(mode),
                    .image(tarot.image)
                ]
                
                if !meaning.tags.isEmpty {
                    elements.append(contentsOf: [
                        .title("Tarot.Keywords".localized),
                        .tags(meaning.tags)
                    ])
                }
                
                meaning.sections.forEach { section in
                    elements.append(.title(section.section))
                    section.blocks.forEach { block in
                        switch block.content {
                        case .text(let text):
                            elements.append(.text(text))
                        case .image(let image):
                            elements.append(.contentImage(image))
                        }
                    }
                }
                
                return elements
            }
    }
    
    func makeTarot() -> Driver<Tarot> {
        tarotId
            .flatMapLatest { [weak self] id -> Driver<Tarot> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Tarot> {
                    self.tarotManager
                        .obtainTarot(id: id)
                        .flatMap { tarot -> Single<Tarot> in
                            guard let tarot = tarot else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(tarot)
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

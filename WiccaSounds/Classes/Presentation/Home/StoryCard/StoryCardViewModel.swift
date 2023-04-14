//
//  StoryCardViewModel.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 25.10.2022.
//

import RxSwift
import RxCocoa
import UIKit

final class StoryCardViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didTappedPrevious = PublishRelay<Void>()
    lazy var didTappedNext = PublishRelay<Void>()
    
    let storyCover: Driver<StoryCover>
    lazy var elements = makeElements()
    lazy var currentIndex = makeCurrentIndex()
    lazy var cardsCount = makeCardsCount()
    lazy var activity = RxActivityIndicator()
    
    private lazy var currentCard = makeCurrentCard()
    private lazy var story = makeStory()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    init(storyCover: StoryCover) {
        self.storyCover = BehaviorRelay(value: storyCover).asDriver()
    }
}

// MARK: Private
private extension StoryCardViewModel {
    func makeElements() -> Driver<[StoryCardTableElement]> {
        currentCard
            .map { card -> [StoryCardTableElement] in
                var result = [StoryCardTableElement]()
                
                if let title = card.title {
                    result.append(.name(title))
                }
                
                card.blocks.enumerated().forEach { index, content in
                    switch content.content {
                    case .image(let url):
                        result.append(.image(url))
                    case .text(let text):
                        result.append(.text(text))
                    }
                }
                
                return result
            }
    }
    
    func makeCurrentCard() -> Driver<StoryCard> {
        Driver
            .combineLatest(currentIndex, story.asDriver())
            .compactMap { currentIndex, story -> StoryCard? in
                story.cards[safe: currentIndex]
            }
    }
    
    func makeCurrentIndex() -> Driver<Int> {
        Observable
            .merge(
                didTappedPrevious.map { -1 },
                didTappedNext.map { 1 }
            )
            .withLatestFrom(cardsCount) { ($0, $1) }
            .scan(0) { index, args -> Int in
                let (step, maxCount) = args
                
                let result = index + step
                
                if result < 0 {
                    return 0
                } else if result > (maxCount - 1) {
                    return maxCount - 1
                }
                
                return result
            }
            .startWith(0)
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeCardsCount() -> Driver<Int> {
        story
            .asDriver()
            .map { $0.cards.count }
    }
    
    func makeStory() -> Driver<Story> {
        storyCover
            .flatMapLatest { [weak self] cover -> Driver<Story> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Story> {
                    self.contentManager
                        .obtainStory(id: cover.id)
                        .flatMap { story -> Single<Story> in
                            guard let story = story else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(story)
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

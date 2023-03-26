//
//  HomeViewModel.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.03.2023.
//

import RxSwift
import RxCocoa

final class HomeViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var sections = makeSections()
    lazy var activity = RxActivityIndicator()
    
    private lazy var homeKit = makeHomeKit()
    
    private lazy var contentManager = ContentManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension HomeViewModel {
    func makeSections() -> Driver<[HomeTableSection]> {
        homeKit
            .map { homeKit -> [HomeTableSection] in
                var sections = [HomeTableSection]()
                
                let todayTitleSection = HomeTableSection(
                    elements: [.todayTitle],
                    corner: false
                )
                sections.append(todayTitleSection)
                
                let todaySection = HomeTableSection(
                    elements: [
                        .spell(homeKit.spellOnDay),
                        .stories(homeKit.stories)
                    ],
                    corner: true
                )
                sections.append(todaySection)
                
                let lunarSection = HomeTableSection(
                    elements: [
                        .lunar(homeKit.lunar)
                    ],
                    corner: true
                )
                sections.append(lunarSection)
                
                return sections
            }
    }
    
    func makeHomeKit() -> Driver<HomeKit> {
        func source() -> Single<HomeKit> {
            contentManager
                .obtainHomeKit()
                .map { homeKit -> HomeKit in
                    guard let homeKit = homeKit else {
                        throw ContentError(.notContent)
                    }
                    
                    return homeKit
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
            .trackActivity(activity)
            .asDriver(onErrorDriveWith: .never())
    }
}

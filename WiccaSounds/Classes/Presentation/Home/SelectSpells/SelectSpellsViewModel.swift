//
//  SelectSpellsViewModel.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 14.04.2023.
//

import RxSwift
import RxCocoa

final class SelectSpellsViewModel {
    enum Route {
        case dismiss
    }
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    lazy var didSelectCategories = PublishRelay<[SpellsCategory]>()
    
    lazy var route = makeRoute()
    lazy var elements = makeElements()
    lazy var activity = RxActivityIndicator()
    
    private lazy var spellsCategories = makeSpellsCategories()
    private lazy var currentSpellsCategoriesIds = makeCurrentSpellsCategoriesIds()
    
    private lazy var spellsManager = SpellsManager()
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
}

// MARK: Private
private extension SelectSpellsViewModel {
    func makeRoute() -> Driver<Route> {
        didSelectCategories
            .flatMapLatest { [weak self] categories -> Driver<Route> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Route> {
                    self.profileManager
                        .set(spellsCategoriesIds: categories.map { $0.id })
                        .map { Route.dismiss }
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
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeElements() -> Driver<[OSpellsCategoriesTableElement]> {
        Driver
            .combineLatest(
                spellsCategories,
                currentSpellsCategoriesIds
            )
            .map { categories, ids -> [OSpellsCategoriesTableElement] in
                categories.map { category -> OSpellsCategoriesTableElement in
                    OSpellsCategoriesTableElement(
                        spellsCategory: category,
                        marked: ids.contains(where: { category.id == $0 })
                    )
                }
            }
    }
    
    func makeSpellsCategories() -> Driver<[SpellsCategory]> {
        spellsManager
            .obtainCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeCurrentSpellsCategoriesIds() -> Driver<[Int]> {
        profileManager
            .obtainProfile(forceUpdate: false)
            .map { $0?.spellsCategoriesIds ?? [] }
            .asDriver(onErrorJustReturn: [])
    }
}

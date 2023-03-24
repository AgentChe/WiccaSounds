//
//  BookmarksViewController.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.03.2023.
//

import UIKit
import RxSwift

final class BookmarksViewController: UIViewController {
    lazy var mainView = BookmarksView()
    
    private lazy var viewModel = BookmarksViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.sections
            .drive(Binder(mainView.tableView) { base, sections in
                base.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        addFilterActions()
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension BookmarksViewController {
    static func make() -> BookmarksViewController {
        let vc = BookmarksViewController()
        vc.navigationItem.backButtonTitle = " "
        vc.navigationItem.title = "Bookmarks.Title".localized
        return vc
    }
}

// MARK: ExploreTableDelegate
extension BookmarksViewController: ExploreTableDelegate {
    func exploreDidTap(spell: ExploreSpellElement) {
        let vc = spell.locked ? PaygateViewController.make() : ContentViewController.make(unit: .spell(spell.spell))
        present(vc, animated: true)
    }
    
    func exploreDidTap(unit: ExploreUnitElement.Unit) {
        let vc: UIViewController
        
        switch unit {
        case .candle(let candle, let locked):
            vc = locked ? PaygateViewController.make() : ContentViewController.make(unit: .candle(candle))
        case .herb(let herb, let locked):
            vc = locked ? PaygateViewController.make() : ContentViewController.make(unit: .herb(herb))
        case .crystal(let crystal, let locked):
            vc = locked ? PaygateViewController.make() : ContentViewController.make(unit: .crystal(crystal))
        }
        
        present(vc, animated: true)
    }
}

// MARK: Private
private extension BookmarksViewController {
    func addFilterActions() {
        Observable
            .merge(
                mainView.filterView.spellsItem.rx.tap
                    .map { ExploreFilterView.Filter.spells },
                mainView.filterView.candlesItem.rx.tap
                    .map { ExploreFilterView.Filter.candles },
                mainView.filterView.herbsItem.rx.tap
                    .map { ExploreFilterView.Filter.herbs },
                mainView.filterView.crystalsItem.rx.tap
                    .map { ExploreFilterView.Filter.crystals }
            )
            .startWith(.spells)
            .bind(to: Binder(self) { base, filter in
                base.viewModel.didTapFilter.accept(filter)
                base.mainView.filterView.filter = filter
            })
            .disposed(by: disposeBag)
    }
}

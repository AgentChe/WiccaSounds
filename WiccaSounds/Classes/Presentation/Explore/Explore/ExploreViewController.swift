//
//  ExploreViewController.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import UIKit
import RxSwift

final class ExploreViewController: UIViewController {
    lazy var mainView = ExploreView()
    
    private lazy var viewModel = ExploreViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var bookmarksButton = UIButton(type: .system)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookmarksButton.rx.tap
            .subscribe(Binder(self) { base, void in
                let vc = BookmarksViewController.make()
                base.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.sections
            .drive(Binder(mainView.tableView) { base, sections in
                base.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        addBookmarksButton()
        addFilterActions()
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Public
extension ExploreViewController {
    static func make() -> ExploreViewController {
        let vc = ExploreViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: ExploreTableDelegate
extension ExploreViewController: ExploreTableDelegate {
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
private extension ExploreViewController {
    func addBookmarksButton() {
        bookmarksButton.setImage(UIImage(named: "Explore.Bookmarks"), for: .normal)
        
        let item = UIBarButtonItem(customView: bookmarksButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
    
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

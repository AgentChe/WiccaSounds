//
//  PracticeViewController.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit
import RxSwift

final class PracticeViewController: UIViewController {
    lazy var mainView = PracticeView()
    
    private lazy var viewModel = PracticeViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared.logEvent(name: "Practice Screen")
        
        viewModel.elements
            .drive(Binder(mainView.collectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        addSelectUnitActions()
        mainView.collectionView.mainDelegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: Make
extension PracticeViewController {
    static func make() -> PracticeViewController {
        let vc = PracticeViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: PracticeCollectionDelegate
extension PracticeViewController: PracticeCollectionDelegate {
    func practiceDidTap(element: PracticeTarotElement) {
        if element.paid {
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        } else {
            let vc = TarotViewController.make(id: element.tarot.id)
            present(vc, animated: true)
        }
    }
    
    func practiceDidTap(element: PracticeRuneElement) {
        if element.paid {
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        } else {
            let vc = RuneViewController.make(id: element.rune.id)
            present(vc, animated: true)
        }
    }
}

// MARK: Private
private extension PracticeViewController {
    func addSelectUnitActions() {
        Observable
            .merge(
                mainView.unitView
                    .tarotButton.rx.tap
                    .map { PracticeUnitView.Unit.tarot },
                mainView.unitView
                    .runesButton.rx.tap
                    .map { PracticeUnitView.Unit.runes }
            )
            .startWith(.tarot)
            .bind(to: Binder(self) { base, unit in
                base.mainView.unitView.setup(unit: unit)
                base.viewModel.didSelectUnit.accept(unit)
                base.log(tap: unit)
            })
            .disposed(by: disposeBag)
    }
    
    func log(tap unit: PracticeUnitView.Unit) {
        let what: String
        switch unit {
        case .tarot:
            what = "tarot"
        case .runes:
            what = "runes"
        }
        
        AmplitudeManager.shared.logEvent(name: "Practice Tap", parameters: ["what": what])
    }
}

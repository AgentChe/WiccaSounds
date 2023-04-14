//
//  SelectSpellsViewController.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 14.04.2023.
//

import UIKit
import RxSwift

final class SelectSpellsViewController: UIViewController {
    lazy var mainView = SelectSpellsView()
    
    private lazy var viewModel = SelectSpellsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.open(error: error)
        }
        
        viewModel.elements
            .drive(Binder(self) { base, elements in
                base.mainView.tableView.setup(elements: elements)
                base.buttonSelection()
            })
            .disposed(by: disposeBag)
        
        viewModel.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(Binder(self) { base, activity in
                base.activity(activity)
            })
            .disposed(by: disposeBag)
        
        mainView.continueButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.buttonTapped()
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension SelectSpellsViewController {
    static func make() -> SelectSpellsViewController {
        let vc = SelectSpellsViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: OSpellsCategoriesTableDelegate
extension SelectSpellsViewController: OSpellsCategoriesTableDelegate {
    func onbSpellsCategoriesTableDidMarked(element: OSpellsCategoriesTableElement) {
        buttonSelection()
    }
}

// MARK: Private
private extension SelectSpellsViewController {
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
    
    func buttonSelection() {
        let hasMarked = mainView.tableView.elements.contains(where: { $0.marked })
        
        mainView.continueButton.isEnabled = hasMarked
        mainView.continueButton.alpha = hasMarked ? 1 : 0.4
    }
    
    func buttonTapped() {
        let categories = mainView.tableView.elements
            .filter { $0.marked }
            .map { $0.spellsCategory }
        viewModel.didSelectCategories.accept(categories)
    }
    
    func route(_ route: SelectSpellsViewModel.Route) {
        switch route {
        case .dismiss:
            dismiss(animated: true)
        }
    }
    
    func activity(_ activity: Bool) {
        mainView.continueButton.isHidden = activity
        activity ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
    }
}

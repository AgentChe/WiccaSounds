//
//  SelectSoundViewController.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 27.04.2023.
//

import UIKit
import RxSwift

final class SelectSoundViewController: UIViewController {
    lazy var mainView = SelectSoundView()
    
    private lazy var viewModel = SelectSoundViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let didSelect: ((SoundCellElement) -> Void)
    
    private init(didSelect: @escaping ((SoundCellElement) -> Void)) {
        self.didSelect = didSelect
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.bundle
            .drive(Binder(mainView.tableView) { base, bundle in
                base.setup(noiseCategories: bundle.0, isActiveSubscription: bundle.1)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension SelectSoundViewController {
    static func make(didSelect: @escaping ((SoundCellElement) -> Void)) -> SelectSoundViewController {
        SelectSoundViewController(didSelect: didSelect)
    }
}

// MARK: SelectSoundTableDelegate
extension SelectSoundViewController: SelectSoundTableDelegate {
    func selectSoundTable(element: SoundCellElement) {
        if element.isActiveSubscription {
            dismiss(animated: true) { [weak self] in
                self?.didSelect(element)
            }
        } else {
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
}

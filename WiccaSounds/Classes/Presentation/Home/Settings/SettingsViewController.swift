//
//  SettingsViewController.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 14.04.2023.
//

import UIKit
import RxSwift

final class SettingsViewController: UIViewController {
    lazy var mainView = SettingsView()
    
    private lazy var viewModel = SettingsViewModel()
    
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
        
        mainView.tableView.mainDelegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: Make
extension SettingsViewController {
    static func make() -> SettingsViewController {
        let vc = SettingsViewController()
        vc.title = "Settings.Title".localized
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: SettingsTableDelegate
extension SettingsViewController: SettingsTableDelegate {
    func settingsDidTap(element: SettingsTableElement) {
        switch element {
        case .favoriteSpells:
            let vc = SelectSpellsViewController.make()
            present(vc, animated: true)
        case .contactUs:
            UIApplication.shared.open(GlobalDefinitions.contactUsUrl)
        case .privacyPolice:
            UIApplication.shared.open(GlobalDefinitions.privacyPolicyUrl)
        case .termsOfUse:
            UIApplication.shared.open(GlobalDefinitions.termsOfServiceUrl)
        }
    }
}

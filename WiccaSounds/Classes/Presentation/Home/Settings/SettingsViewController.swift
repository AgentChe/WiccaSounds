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
        
        AmplitudeManager.shared.logEvent(name: "Settings Screen")
        
        viewModel.sections
            .drive(Binder(mainView.tableView) { base, sections in
                base.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingToParent {
            AmplitudeManager.shared.logEvent(name: "Settings Tap", parameters: ["what": "back"])
        }
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
            AmplitudeManager.shared.logEvent(name: "Settings Tap", parameters: ["what": "fav spells"])
            
            let vc = SelectSpellsViewController.make()
            present(vc, animated: true)
        case .contactUs:
            AmplitudeManager.shared.logEvent(name: "Settings Tap", parameters: ["what": "contact us"])
            open(path: GlobalDefinitions.contactUsUrl)
        case .privacyPolice:
            AmplitudeManager.shared.logEvent(name: "Settings Tap", parameters: ["what": "privacy policy"])
            open(path: GlobalDefinitions.privacyPolicyUrl)
        case .termsOfUse:
            AmplitudeManager.shared.logEvent(name: "Settings Tap", parameters: ["what": "terms of use"])
            open(path: GlobalDefinitions.termsOfServiceUrl)
        }
    }
}

// MARK: Private
private extension SettingsViewController {
    func open(path: String) {
        guard let url = URL(string: path) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
}

//
//  HomeViewController.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.03.2023.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    lazy var mainView = HomeView()
    
    private lazy var viewModel = HomeViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var settingsButton = UIButton(type: .system)
    
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
        
        viewModel.sections
            .drive(Binder(mainView.tableView) { base, sections in
                base.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        viewModel.activity
            .drive(Binder(mainView.preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        settingsButton.rx.tap
            .bind(to: Binder(self) { base, void in
                let vc = SettingsViewController.make()
                base.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        addSettingsButton()
        mainView.tableView.mainDelegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: Make
extension HomeViewController {
    static func make() -> HomeViewController {
        let vc = HomeViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: HomeTableDelegate
extension HomeViewController: HomeTableDelegate {
    func homeTableDidTap(spell: Spell) {
        let vc = ContentViewController.make(unit: ContentViewModel.Unit.spell(spell))
        present(vc, animated: true)
    }
    
    func homeTableDidTap(story: StoryCover) {
        let vc = StoryCardViewController.make(storyCover: story)
        present(vc, animated: true)
    }
    
    func homeTableDidTap(tipElement: HomeTipElement) {
        if tipElement.locked {
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        } else {
            viewModel.didTapTip.accept(tipElement.tip)
        }
    }
    
    func homeTableDidOpen(tarot: TarotOnDay) {
        viewModel.didOpenTarot.accept(tarot)
    }
    
    func homeTableDidShow(tarotCover: TarotCover) {
        let vc = TarotViewController.make(id: tarotCover.id)
        present(vc, animated: true)
    }
    
    func homeTableDidOpen(rune: RuneOnDay) {
        viewModel.didOpenRune.accept(rune)
    }
    
    func homeTableDidShow(runeCover: RuneCover) {
        let vc = RuneViewController.make(id: runeCover.id)
        present(vc, animated: true)
    }
}

// MARK: Private
private extension HomeViewController {
    func addSettingsButton() {
        settingsButton.setImage(UIImage(named: "Home.Settings"), for: .normal)
        
        let item = UIBarButtonItem(customView: settingsButton)
        item.customView?.translatesAutoresizingMaskIntoConstraints = false
        
        item.customView?.widthAnchor.constraint(equalToConstant: 24.scale).isActive = true
        item.customView?.heightAnchor.constraint(equalToConstant: 24.scale).isActive = true
        
        navigationItem.rightBarButtonItem = item
    }
    
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
}

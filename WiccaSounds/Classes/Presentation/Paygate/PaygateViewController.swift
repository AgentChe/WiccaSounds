//
//  PaygateViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import UIKit
import RxSwift

final class PaygateViewController: UIViewController {
    weak var delegate: PaygateViewControllerDelegate?
    
    lazy var mainView =  PaygateView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = PaygateViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared
            .logEvent(name: "Paygate Screen", parameters: [:])
        FirebaseManager.shared
            .logEvent(name: "client_paygate_screen")
        
        viewModel.prices
            .drive(Binder(self) { base, prices in
                base.mainView.topOptionButton.price = prices.first(where: { $0.id == GlobalDefinitions.Paygate.defaultLifetime })
                base.mainView.bottomOptionButton.price = prices.first(where: { $0.id == GlobalDefinitions.Paygate.defaultMonthly })
                base.setupPriceForCell(prices: prices)
            })
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                mainView.topOptionButton.rx.tap
                    .compactMap { [weak self] in self?.mainView.topOptionButton.price?.id }
                    .asObservable(),
                mainView.bottomOptionButton.rx.tap
                    .compactMap { [weak self] in self?.mainView.bottomOptionButton.price?.id }
                    .asObservable()
            )
            .bind(to: viewModel.buy)
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                mainView.termsOfServiceButton.rx.tap.map { GlobalDefinitions.termsOfServiceUrl },
                mainView.privacyPolicyButton.rx.tap.map { GlobalDefinitions.privacyPolicyUrl }
            )
            .subscribe(onNext: { path in
                guard let url = URL(string: path) else {
                    return
                }
                
                UIApplication.shared.open(url, options: [:])
            })
            .disposed(by: disposeBag)
        
        mainView.restoreButton.rx.tap
            .bind(to: viewModel.restore)
            .disposed(by: disposeBag)
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(with: .cancelled)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .buyed
            .emit(onNext: { [weak self] success in
                if !success {
                    Toast.notify(with: "Paygate.Failed".localized, style: .danger)
                    return
                }
                
                self?.dismiss(with: .bied)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .restored
            .emit(onNext: { [weak self] result in
                if !result {
                    Toast.notify(with: "Paygate.Failed".localized, style: .danger)
                    return
                }
                
                self?.dismiss(with: .restored)
            })
            .disposed(by: disposeBag)
        
        viewModel.activityIndicator
            .drive(Binder(self) { base, active in
                base.activityIndicator(active: active)
            })
            .disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: Make
extension PaygateViewController {
    static func make() -> PaygateViewController {
        let vc = PaygateViewController()
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension PaygateViewController {
    func dismiss(with result: PaygateViewControllerResult) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.delegate?.paygateDidClosed(with: result)
        }
    }
    
    func activityIndicator(active: Bool) {
        active ? mainView.preloader.startAnimating() : mainView.preloader.stopAnimating()
        
        mainView.topOptionButton.isHidden = active
        mainView.bottomOptionButton.isHidden = active
        mainView.restoreButton.isHidden = active
    }
    
    func setupPriceForCell(prices: [ProductPrice]) {
        guard
            let lifetime = prices.first(where: { GlobalDefinitions.Paygate.defaultLifetime == $0.id })?.priceLocalized,
            let monthly = prices.first(where: { GlobalDefinitions.Paygate.defaultMonthly == $0.id })?.priceLocalized
        else {
            return
        }
        
        let string = String(format: "Paygate.Cell5".localized, lifetime, monthly)
        mainView.cell5.setup(text: string, isSmall: true)
    }
}

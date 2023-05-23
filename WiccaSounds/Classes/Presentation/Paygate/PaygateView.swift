//
//  PaygateView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import UIKit

final class PaygateView: GradientView {
    lazy var imageView = makeImageView()
    lazy var closeButton = makeCloseButton()
    lazy var cell1 = makeCell(text: "Paygate.Cell1".localized)
    lazy var cell2 = makeCell(text: "Paygate.Cell2".localized)
    lazy var cell3 = makeCell(text: "Paygate.Cell3".localized)
    lazy var cell4 = makeCell(text: "Paygate.Cell4".localized)
    lazy var cell5 = makeCell(text: "")
    lazy var cell6 = makeCell(text: "Paygate.Cell6".localized)
    lazy var topOptionButton = makeProductButton()
    lazy var bottomOptionButton = makeProductButton()
    lazy var restoreButton = makeRestoreButton()
    lazy var termsOfServiceButton = makeTermsOfServiceButton()
    lazy var privacyPolicyButton = makePrivacyPolicyButton()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension PaygateView {
    func initialize() {
        gradientLayer.colors = [
            UIColor(integralRed: 249, green: 248, blue: 0).cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0, 0.4, 1]
    }
}

// MARK: Make constraints
private extension PaygateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 149.scale : 117.scale),
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 149.scale : 117.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 52.scale : 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 60.scale : 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell1.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 12.scale : 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 12.scale : 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell4.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell4.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell4.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 12.scale : 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell5.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell5.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell5.topAnchor.constraint(equalTo: cell4.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 12.scale : 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell6.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell6.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell6.topAnchor.constraint(equalTo: cell5.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 12.scale : 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            topOptionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            topOptionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            topOptionButton.heightAnchor.constraint(equalToConstant: 56.scale),
            topOptionButton.topAnchor.constraint(equalTo: cell6.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 20.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomOptionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            bottomOptionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            bottomOptionButton.heightAnchor.constraint(equalToConstant: 56.scale),
            bottomOptionButton.topAnchor.constraint(equalTo: topOptionButton.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 16.scale : 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            restoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            restoreButton.topAnchor.constraint(equalTo: bottomOptionButton.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 16.scale : 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfServiceButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            termsOfServiceButton.topAnchor.constraint(equalTo: restoreButton.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            privacyPolicyButton.topAnchor.constraint(equalTo: restoreButton.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: topOptionButton.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage(named: "Paygate.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Paygate.Close"), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(text: String) -> PaygateInfoCell {
        let view = PaygateInfoCell()
        view.setup(text: text)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProductButton() -> PaygateProductButton {
        let view = PaygateProductButton()
        view.backgroundColor = UIColor(integralRed: 1, green: 169, blue: 94)
        view.layer.cornerRadius = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRestoreButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.PlayfairDisplay.regular(size: ScreenSize.isIphoneXFamily ? 17.scale : 15.scale))
            .lineHeight(ScreenSize.isIphoneXFamily ? 23.8.scale : 21.scale)
            .letterSpacing(0.17.scale)
        
        let view = TapAreaButton()
        view.setAttributedTitle("Paygate.Restore".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTermsOfServiceButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.PlayfairDisplay.regular(size: ScreenSize.isIphoneXFamily ? 17.scale : 15.scale))
            .letterSpacing(0.17.scale)
            .underlineColor(Appearance.white)
            .underlineStyle(.single)
        
        let view = TapAreaButton()
        view.setAttributedTitle("Paygate.TermsAndCondition".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePrivacyPolicyButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.PlayfairDisplay.regular(size: ScreenSize.isIphoneXFamily ? 17.scale : 15.scale))
            .letterSpacing(0.17.scale)
            .underlineColor(Appearance.white)
            .underlineStyle(.single)
        
        let view = TapAreaButton()
        view.setAttributedTitle("Paygate.PrivacyPolicy".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

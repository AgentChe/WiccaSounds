//
//  PaygateView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import UIKit

final class PaygateView: UIView {
    lazy var imageView = makeImageView()
    lazy var closeButton = makeCloseButton()
    lazy var restoreButton = makeRestoreButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var reviewsView = makeReviewsView()
    lazy var cell1 = makeCell(text: "Paygate.Cell1.Text".localized)
    lazy var cell2 = makeCell(text: "Paygate.Cell2.Text".localized)
    lazy var topOptionButton = makeProductButton()
    lazy var bottomOptionButton = makeProductButton()
    lazy var securedView = makeSecuredView()
    lazy var securedLabel = makeSecuredLabel()
    lazy var continueButton = makeContinueButton()
    lazy var termsOfServiceButton = makeTermsOfServiceButton()
    lazy var andLabel = makeAndLabel()
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

// MARK: Public
extension PaygateView {
    func animateScrollReviews() {
        let no = reviewsView.contentOffset.x + 1
        
        UIView.animate(withDuration: 0.001, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            self?.reviewsView.contentOffset = CGPoint(x: no, y: 0)
        }, completion: { [weak self] _ in
            self?.animateScrollReviews()
        })
    }
}

// MARK: Private
private extension PaygateView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension PaygateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 265.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ScreenSize.isIphoneXFamily ? 16.scale : 5.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 64.scale : 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            restoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ScreenSize.isIphoneXFamily ? -16.scale : -8.scale),
            restoreButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 16.scale : 14.scale)
        ])
        
        NSLayoutConstraint.activate([
            reviewsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            reviewsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            reviewsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 20.scale : 12.scale),
            reviewsView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 136.scale : 118.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell1.topAnchor.constraint(equalTo: reviewsView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 18.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            topOptionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            topOptionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            topOptionButton.heightAnchor.constraint(equalToConstant: 76.scale),
            topOptionButton.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 30.scale : 14.scale)
        ])
        
        NSLayoutConstraint.activate([
            bottomOptionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            bottomOptionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            bottomOptionButton.heightAnchor.constraint(equalToConstant: 76.scale),
            bottomOptionButton.topAnchor.constraint(equalTo: topOptionButton.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            securedView.widthAnchor.constraint(equalToConstant: 17.scale),
            securedView.heightAnchor.constraint(equalToConstant: 17.scale),
            securedView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 53.scale),
            securedView.topAnchor.constraint(equalTo: bottomOptionButton.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 38.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            securedLabel.leadingAnchor.constraint(equalTo: securedView.trailingAnchor, constant: 5.scale),
            securedLabel.centerYAnchor.constraint(equalTo: securedView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 56.scale),
            continueButton.topAnchor.constraint(equalTo: securedView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 16.scale : 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfServiceButton.trailingAnchor.constraint(equalTo: andLabel.leadingAnchor, constant: -4.scale),
            termsOfServiceButton.centerYAnchor.constraint(equalTo: andLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            andLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            andLabel.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 26.scale : 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.leadingAnchor.constraint(equalTo: andLabel.trailingAnchor, constant: 4.scale),
            privacyPolicyButton.centerYAnchor.constraint(equalTo: andLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: continueButton.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor)
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
    
    func makeRestoreButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 252, green: 252, blue: 252))
            .font(Fonts.PlusJakartaSans.regular(size: 14.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("Paygate.RestorePurchases".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.PlusJakartaSans.extraBold(size: 30.scale))
            .lineHeight(36.scale)
            .letterSpacing(0.16.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Paygate.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeReviewsView() -> ReviewsView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = ScreenSize.isIphoneXFamily ? 16.scale : 12.scale
        
        let view = ReviewsView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, left: 16.scale, bottom: 0, right: 16.scale)
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
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.white.withAlphaComponent(0.15).cgColor
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSecuredView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Paygate.Secured")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSecuredLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white.withAlphaComponent(0.6))
            .font(Fonts.Inter.regular(size: 14.scale))
            .lineHeight(16.94.scale)
        
        let view = UILabel()
        view.attributedText = "Paygate.Secured".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .letterSpacing(0.17.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Paygate.Subscribe".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.primary
        view.layer.cornerRadius = 28.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTermsOfServiceButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.PlusJakartaSans.regular(size: 14.scale))
            .lineHeight(17.scale)
        
        let view = TapAreaButton()
        view.setAttributedTitle("Paygate.TermsOfUse".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAndLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 233, green: 231, blue: 228))
            .font(Fonts.PlusJakartaSans.regular(size: 12.scale))
            .lineHeight(15.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Paygate.And".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePrivacyPolicyButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.PlusJakartaSans.regular(size: 14.scale))
            .lineHeight(17.scale)
        
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

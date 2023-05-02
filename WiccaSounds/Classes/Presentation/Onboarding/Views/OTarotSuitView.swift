//
//  OTarotSuitView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.03.2023.
//

import UIKit

final class OTarotSuitView: OSlideView {
    enum TarotSuit {
        case pentacles, wands, cups, swords
    }
    
    lazy var titleLabel = makeTitleLabel()
    lazy var pentaclesCell = makeCell(element: .pentacles)
    lazy var wandsCell = makeCell(element: .wands)
    lazy var cupsCell = makeCell(element: .cups)
    lazy var swordsCell = makeCell(element: .swords)
    lazy var continueButton = makeContinueButton()
    
    private lazy var cells = [
        pentaclesCell,
        wandsCell,
        cupsCell,
        swordsCell
    ]
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        continueEnableChanged()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        AmplitudeManager.shared.logEvent(name: "Onboarding Question Screen", parameters: ["step": 3])
    }
}

// MARK: Private
private extension OTarotSuitView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func didTap(sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? OTarotSuitCell else {
            return
        }
        
        cells.forEach { $0.marked = false }
        
        cell.marked = true
        
        continueEnableChanged()
    }
    
    func continueEnableChanged() {
        let hasMarked = cells.contains(where: { $0.marked })
        
        continueButton.isEnabled = hasMarked
        continueButton.alpha = hasMarked ? 1 : 0.4
    }
}

// MARK: Make constraints
private extension OTarotSuitView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 90.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            pentaclesCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            pentaclesCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            pentaclesCell.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale),
            pentaclesCell.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            wandsCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            wandsCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            wandsCell.topAnchor.constraint(equalTo: pentaclesCell.bottomAnchor, constant: 12.scale),
            wandsCell.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            cupsCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            cupsCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            cupsCell.topAnchor.constraint(equalTo: wandsCell.bottomAnchor, constant: 12.scale),
            cupsCell.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            swordsCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            swordsCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            swordsCell.topAnchor.constraint(equalTo: cupsCell.bottomAnchor, constant: 12.scale),
            swordsCell.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 56.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OTarotSuitView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.bold(size: 20.scale))
            .lineHeight(24.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.TarotSuit.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(element: TarotSuit) -> OTarotSuitCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = OTarotSuitCell(element: element)
        view.backgroundColor = Appearance.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10.scale
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .letterSpacing(0.8.scale)
        
        let view = UIButton()
        view.backgroundColor = Appearance.primary
        view.layer.cornerRadius = 28.scale
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

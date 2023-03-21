//
//  OMoonSacredView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.03.2023.
//

import UIKit

final class OMoonSacredView: OSlideView {
    enum MoonSacred {
        case yes, notSure, no
    }
    
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(element: .yes)
    lazy var cell2 = makeCell(element: .notSure)
    lazy var cell3 = makeCell(element: .no)
    lazy var continueButton = makeContinueButton()
    
    private lazy var cells = [
        cell1,
        cell2,
        cell3
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
}

// MARK: Private
private extension OMoonSacredView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func didTap(sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? OMoonSacredCell else {
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
private extension OMoonSacredView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 90.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            cell1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale),
            cell1.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 12.scale),
            cell2.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 12.scale),
            cell3.heightAnchor.constraint(equalToConstant: 72.scale)
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
private extension OMoonSacredView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.bold(size: 20.scale))
            .lineHeight(24.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.MoonSacred.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(element: MoonSacred) -> OMoonSacredCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = OMoonSacredCell(element: element)
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

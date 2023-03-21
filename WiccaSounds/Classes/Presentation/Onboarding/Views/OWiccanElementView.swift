//
//  OWiccanElementView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.03.2023.
//

import UIKit

final class OWiccanElementView: OSlideView {
    enum WiccanElement {
        case water, earth, air, fire, spirit
    }
    
    lazy var titleLabel = makeTitleLabel()
    lazy var waterCell = makeCell(element: .water)
    lazy var earthCell = makeCell(element: .earth)
    lazy var airCell = makeCell(element: .air)
    lazy var fireCell = makeCell(element: .fire)
    lazy var spiritCell = makeCell(element: .spirit)
    lazy var continueButton = makeContinueButton()
    
    private lazy var cells = [
        waterCell,
        earthCell,
        airCell,
        fireCell,
        spiritCell
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
private extension OWiccanElementView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func didTap(sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? WiccanElementCell else {
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
private extension OWiccanElementView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 90.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            waterCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            waterCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            waterCell.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale),
            waterCell.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            earthCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            earthCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            earthCell.topAnchor.constraint(equalTo: waterCell.bottomAnchor, constant: 12.scale),
            earthCell.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            airCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            airCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            airCell.topAnchor.constraint(equalTo: earthCell.bottomAnchor, constant: 12.scale),
            airCell.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            fireCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            fireCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            fireCell.topAnchor.constraint(equalTo: airCell.bottomAnchor, constant: 12.scale),
            fireCell.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            spiritCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            spiritCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            spiritCell.topAnchor.constraint(equalTo: fireCell.bottomAnchor, constant: 12.scale),
            spiritCell.heightAnchor.constraint(equalToConstant: 72.scale)
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
private extension OWiccanElementView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.bold(size: 20.scale))
            .lineHeight(24.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.WiccanElement.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(element: WiccanElement) -> WiccanElementCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = WiccanElementCell(element: element)
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

//
//  OObjectsChannelView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import UIKit

final class OObjectsChannelView: OSlideView {
    enum ObjectChannel {
        case herbs, crystals, oils, candles
    }
    
    lazy var titleLabel = makeTitleLabel()
    lazy var herbsCell = makeCell(element: .herbs)
    lazy var crystalsCell = makeCell(element: .crystals)
    lazy var oilsCell = makeCell(element: .oils)
    lazy var candlesCell = makeCell(element: .candles)
    lazy var continueButton = makeContinueButton()
    
    private lazy var cells = [
        herbsCell,
        crystalsCell,
        oilsCell,
        candlesCell
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
private extension OObjectsChannelView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func didTap(sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? OObjectChannelCell else {
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
private extension OObjectsChannelView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 90.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            herbsCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            herbsCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            herbsCell.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale),
            herbsCell.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            crystalsCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            crystalsCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            crystalsCell.topAnchor.constraint(equalTo: herbsCell.bottomAnchor, constant: 12.scale),
            crystalsCell.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            oilsCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            oilsCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            oilsCell.topAnchor.constraint(equalTo: crystalsCell.bottomAnchor, constant: 12.scale),
            oilsCell.heightAnchor.constraint(equalToConstant: 72.scale)
        ])
        
        NSLayoutConstraint.activate([
            candlesCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            candlesCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            candlesCell.topAnchor.constraint(equalTo: oilsCell.bottomAnchor, constant: 12.scale),
            candlesCell.heightAnchor.constraint(equalToConstant: 72.scale)
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
private extension OObjectsChannelView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.bold(size: 20.scale))
            .lineHeight(24.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.ObjectsChannel.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(element: ObjectChannel) -> OObjectChannelCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = OObjectChannelCell(element: element)
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

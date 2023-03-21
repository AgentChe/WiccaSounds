//
//  OObjectChannelCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import UIKit

final class OObjectChannelCell: UIView {
    let element: OObjectsChannelView.ObjectChannel
    
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var titleLabel = makeTitleLabel()
    lazy var iconView = makeIconView()
    
    init(element: OObjectsChannelView.ObjectChannel) {
        self.element = element
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OObjectChannelCell {
    func update() {
        let selectedColor = Appearance.second.cgColor
        let unselectedColor = Appearance.white.withAlphaComponent(0.15).cgColor
        
        layer.borderColor = marked ? selectedColor : unselectedColor
        layer.borderWidth = marked ? 2.scale : 1.scale
    }
    
    func title() -> String {
        switch element {
        case .herbs:
            return "Onboarding.ObjectsChannel.Herbs".localized
        case .crystals:
            return "Onboarding.ObjectsChannel.Crystals".localized
        case .oils:
            return "Onboarding.ObjectsChannel.Oils".localized
        case .candles:
            return "Onboarding.ObjectsChannel.Candles".localized
        }
    }
    
    func iconName() -> String {
        switch element {
        case .herbs:
            return "Onboarding.ObjectsChannel.Herbs"
        case .crystals:
            return "Onboarding.ObjectsChannel.Crystals"
        case .oils:
            return "Onboarding.ObjectsChannel.Oils"
        case .candles:
            return "Onboarding.ObjectsChannel.Candles"
        }
    }
}

// MARK: Make constraints
private extension OObjectChannelCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -88.scale),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 52.scale),
            iconView.heightAnchor.constraint(equalToConstant: 52.scale),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OObjectChannelCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .letterSpacing(0.14.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 2
        view.attributedText = title().attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: iconName())
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

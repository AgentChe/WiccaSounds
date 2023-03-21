//
//  OMoonSacredCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.03.2023.
//

import UIKit

final class OMoonSacredCell: UIView {
    let element: OMoonSacredView.MoonSacred
    
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var titleLabel = makeTitleLabel()
    lazy var iconView = makeIconView()
    
    init(element: OMoonSacredView.MoonSacred) {
        self.element = element
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OMoonSacredCell {
    func update() {
        let selectedColor = Appearance.second.cgColor
        let unselectedColor = Appearance.white.withAlphaComponent(0.15).cgColor
        
        layer.borderColor = marked ? selectedColor : unselectedColor
        layer.borderWidth = marked ? 2.scale : 1.scale
    }
    
    func title() -> String {
        switch element {
        case .yes:
            return "Onboarding.MoonSacred.Cell1".localized
        case .notSure:
            return "Onboarding.MoonSacred.Cell2".localized
        case .no:
            return "Onboarding.MoonSacred.Cell3".localized
        }
    }
    
    func iconName() -> String {
        switch element {
        case .yes:
            return "Onboarding.MoonSacred.Cell1"
        case .notSure:
            return "Onboarding.MoonSacred.Cell2"
        case .no:
            return "Onboarding.MoonSacred.Cell3"
        }
    }
}

// MARK: Make constraints
private extension OMoonSacredCell {
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
private extension OMoonSacredCell {
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

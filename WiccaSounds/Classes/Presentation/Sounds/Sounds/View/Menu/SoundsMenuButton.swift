//
//  SoundsMenuButton.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 27.04.2023.
//

import UIKit

final class SoundsMenuButton: UIButton {
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    lazy var separator = makeSeparator()
    
    private let iconName: String
    private let title: String
    
    init(iconName: String, title: String) {
        self.iconName = iconName
        self.title = title
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension SoundsMenuButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 28.scale),
            iconView.heightAnchor.constraint(equalToConstant: 28.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 54.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SoundsMenuButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: iconName)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.background)
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.background.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

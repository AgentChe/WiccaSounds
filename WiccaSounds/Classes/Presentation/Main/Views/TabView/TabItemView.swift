//
//  TabItemView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

final class TabItemView: UIButton {
    lazy var iconView = makeImageView()
    lazy var label = makeLabel()
    
    var marked = false {
        didSet {
            update()
        }
    }
    
    private let code: String
    
    init(code: String) {
        self.code = code
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabItemView {
    func update() {
        alpha = marked ? 1 : 0.6
        
        let imageAdditionalCode = marked ? ".Selected" : ".Deselected"
        iconView.image = UIImage(named: code + imageAdditionalCode)
        
        let attrs = TextAttributes()
            .font(Fonts.PlusJakartaSans.semiBold(size: 11.scale))
            .textColor(marked ? UIColor(integralRed: 84, green: 151, blue: 116) : Appearance.white)
            .lineHeight(13.scale)
            .textAlignment(.center)
        label.attributedText = code.localized.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension TabItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 6.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TabItemView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

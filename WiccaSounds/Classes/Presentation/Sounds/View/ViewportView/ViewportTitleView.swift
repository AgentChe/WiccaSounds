//
//  ViewportTitleView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 27.04.2023.
//

import UIKit

final class ViewportTitleView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var arrowView = makeArrowView()
    lazy var menuButton = makeMenuButton()
    lazy var addButton = makeAddButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension ViewportTitleView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.widthAnchor.constraint(equalToConstant: 13.scale),
            arrowView.heightAnchor.constraint(equalToConstant: 8.scale),
            arrowView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10.scale),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            menuButton.trailingAnchor.constraint(equalTo: arrowView.trailingAnchor),
            menuButton.topAnchor.constraint(equalTo: topAnchor),
            menuButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 24.scale),
            addButton.heightAnchor.constraint(equalToConstant: 24.scale),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ViewportTitleView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white.withAlphaComponent(0.4))
            .font(Fonts.Inter.bold(size: 20.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.3.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Sounds.MenuTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeArrowView() -> UIImageView {
        let view = UIImageView()
        view.alpha = 0.4
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Sounds.Arrow.Down")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeMenuButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAddButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Sounds.Add"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

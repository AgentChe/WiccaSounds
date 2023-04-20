//
//  ReviewCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 19.04.2023.
//

import UIKit

final class ReviewCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var iconView = makeImageView()
    lazy var textLabel = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.regular(size: ScreenSize.isIphoneXFamily ? 16.scale : 14.scale))
        .lineHeight(ScreenSize.isIphoneXFamily ? 22.4.scale : 19.6.scale)
    
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
extension ReviewCell {
    func setup(element: ReviewElement) {
        iconView.image = UIImage(named: element.image)
        
        textLabel.attributedText = element.text.attributed(with: attrs)
    }
}

// MARK: Private
private extension ReviewCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension ReviewCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 32.scale : 28.scale),
            iconView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 32.scale : 28.scale),
            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10.scale),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: ScreenSize.isIphoneXFamily ? 18.scale : 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: ScreenSize.isIphoneXFamily ? 18.scale : 12.scale),
            textLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: ScreenSize.isIphoneXFamily ? -14.scale : -12.scale),
            textLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: ScreenSize.isIphoneXFamily ? 50.scale : 46.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ReviewCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10.scale
        view.layer.borderColor = Appearance.white.withAlphaComponent(0.15).cgColor
        view.layer.borderWidth = 1.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}

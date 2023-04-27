//
//  SoundCell.swift
//  SleepWell
//
//  Created by Vitaliy Zagorodnov on 04/01/2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit
import Kingfisher

final class SoundCell: UICollectionViewCell {
    lazy var imageView = makeImageView()
    lazy var nameLabel = makeNameLabel()
    lazy var lockedView = makeLockedView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(22.4.scale)
        .textAlignment(.center)
        .lineBreakMode(.byTruncatingTail)
    
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
extension SoundCell {
    func setup(image: URL, title: String, isActiveSubscription: Bool) {
        imageView.kf.setImage(with: image, options: [.transition(.fade(0.2))])
        nameLabel.attributedText = title.attributed(with: attrs)
        lockedView.isHidden = isActiveSubscription
    }
}

// MARK: Private
private extension SoundCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension SoundCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 76.scale),
            imageView.heightAnchor.constraint(equalToConstant: 76.scale),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            lockedView.widthAnchor.constraint(equalToConstant: 32.scale),
            lockedView.heightAnchor.constraint(equalToConstant: 32.scale),
            lockedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lockedView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SoundCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 38.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLockedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Sounds.Locked")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

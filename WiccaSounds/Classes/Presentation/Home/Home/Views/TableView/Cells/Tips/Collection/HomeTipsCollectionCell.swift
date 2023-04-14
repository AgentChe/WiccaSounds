//
//  HomeTipsCollectionCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 29.03.2023.
//

import UIKit
import Kingfisher

final class HomeTipsCollectionCell: UICollectionViewCell {
    lazy var imageView = makeImageView()
    lazy var lockedView = makeLockedView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}

// MARK: Public
extension HomeTipsCollectionCell {
    func setup(element: HomeTipElement) {
        if !element.locked {
            imageView.kf.setImage(with: element.tip.image)
        }
        
        lockedView.isHidden = !element.locked
    }
}

// MARK: Private
private extension HomeTipsCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension HomeTipsCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 48.scale),
            imageView.heightAnchor.constraint(equalToConstant: 48.scale),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lockedView.widthAnchor.constraint(equalToConstant: 16.scale),
            lockedView.heightAnchor.constraint(equalToConstant: 18.scale),
            lockedView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            lockedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeTipsCollectionCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.backgroundColor = UIColor(integralRed: 70, green: 67, blue: 57)
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 24.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.white.withAlphaComponent(0.15).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLockedView() -> UIImageView {
        let view = UIImageView()
        view.alpha = 0.4
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Home.Locked")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

//
//  PracticeRuneCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit
import Kingfisher

final class PracticeRuneCell: UICollectionViewCell {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeLabel()
    lazy var paidView = makePaidView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.regular(size: 16.scale))
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
}

// MARK: Public
extension PracticeRuneCell {
    func setup(element: PracticeRuneElement) {
        imageView.kf.setImage(with: element.rune.image)
        titleLabel.attributedText = element.rune.name.attributed(with: attrs)
        paidView.isHidden = !element.paid
    }
}

// MARK: Private
private extension PracticeRuneCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension PracticeRuneCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 103.scale),
            imageView.heightAnchor.constraint(equalToConstant: 141.scale),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            paidView.widthAnchor.constraint(equalToConstant: 32.scale),
            paidView.heightAnchor.constraint(equalToConstant: 32.scale),
            paidView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.scale),
            paidView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PracticeRuneCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePaidView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "Practice.Lock")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

//
//  HomeWheelCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 29.03.2023.
//

import UIKit
import Kingfisher

final class HomeWheelCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var pictureView = makeImageView()
    lazy var stackView = makeStackView()
    lazy var nameLabel = makeNameLabel()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.primary)
        .font(Fonts.Inter.semiBold(size: 16.scale))
        .lineHeight(19.2.scale)
        .textAlignment(.left)
    private lazy var contentAttrs = TextAttributes()
        .textColor(UIColor.black.withAlphaComponent(0.7))
        .font(Fonts.Inter.regular(size: 15.scale))
        .lineHeight(24.scale)
        .letterSpacing(-0.5.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomeWheelCell {
    func setup(element: WheelOnYear) {
        pictureView.kf.setImage(with: element.image)
        
        nameLabel.attributedText = element.name.attributed(with: nameAttrs)
        
        element.blocks.forEach { block in
            blockToView(block)
        }
    }
}

// MARK: Private
private extension HomeWheelCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    func blockToView(_ block: ContentBlock) {
        switch block.content {
        case .image(let url):
            let view = UIImageView()
            view.contentMode = .scaleAspectFill
            view.clipsToBounds = true
            view.kf.setImage(with: url)
            view.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(view)
            
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: 279.scale),
                view.heightAnchor.constraint(equalToConstant: 168.scale)
            ])
        case .text(let text):
            let view = UILabel()
            view.attributedText = text.attributed(with: contentAttrs)
            view.numberOfLines = 0
            view.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(view)
        }
    }
}

// MARK: Make constraints
private extension HomeWheelCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            pictureView.widthAnchor.constraint(equalToConstant: 250.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 250.scale),
            pictureView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pictureView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 111.scale),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeWheelCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.bold(size: 18.scale))
            .lineHeight(21.6.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Home.Wheel.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 12.scale
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 24.scale, left: 16.scale, bottom: 24.scale, right: 16.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(view)
        return view
    }
}

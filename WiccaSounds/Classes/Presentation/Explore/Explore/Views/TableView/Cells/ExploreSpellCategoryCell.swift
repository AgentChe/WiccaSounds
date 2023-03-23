//
//  ExploreSpellCategoryCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import UIKit
import Kingfisher

final class ExploreSpellCategoryCell: UITableViewCell {
    lazy var iconView = makeIconView()
    lazy var nameLabel = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.semiBold(size: 16.scale))
        .lineHeight(19.2.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconView.kf.cancelDownloadTask()
        iconView.image = nil
    }
}

// MARK: Public
extension ExploreSpellCategoryCell {
    func setup(element: SpellsCategory) {
        iconView.kf.setImage(with: element.image)
        
        nameLabel.attributedText = element.name.attributed(with: attrs)
    }
}

// MARK: Private
private extension ExploreSpellCategoryCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = Appearance.white.withAlphaComponent(0.1)
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ExploreSpellCategoryCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 56.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ExploreSpellCategoryCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

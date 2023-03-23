//
//  ExploreSpellCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import UIKit

final class ExploreSpellCell: UITableViewCell {
    lazy var iconView = makeIconView()
    lazy var nameLabel = makeNameLabel()
    lazy var lockView = makeLockView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(19.2.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ExploreSpellCell {
    func setup(element: ExploreSpellElement) {
        nameLabel.attributedText = element.spell.name.attributed(with: attrs)
        
        lockView.isHidden = !element.locked
    }
}

// MARK: Private
private extension ExploreSpellCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = Appearance.white.withAlphaComponent(0.1)
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ExploreSpellCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40.scale),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.scale),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            lockView.widthAnchor.constraint(equalToConstant: 14.scale),
            lockView.heightAnchor.constraint(equalToConstant: 16.scale),
            lockView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            lockView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ExploreSpellCell {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Explore.Spell.Icon")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLockView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Explore.Spell.Lock")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

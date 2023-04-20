//
//  OSpellsCategoriesTableCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.03.2023.
//

import UIKit

final class OSpellsCategoriesTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(22.4.scale)
        .letterSpacing(0.14.scale)
        .textAlignment(.left)
    
    private lazy var selectedColor = Appearance.second.cgColor
    private lazy var unselectedColor = Appearance.white.withAlphaComponent(0.15).cgColor
    
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
extension OSpellsCategoriesTableCell {
    func setup(element: OSpellsCategoriesTableElement) {
        titleLabel.attributedText = element.spellsCategory.name.attributed(with: attrs)
        
        container.layer.borderWidth = element.marked ? 2.scale : 1.scale
        container.layer.borderColor = element.marked ? selectedColor : unselectedColor
    }
}

// MARK: Private
private extension OSpellsCategoriesTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension OSpellsCategoriesTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 25.scale),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -25.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSpellsCategoriesTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}

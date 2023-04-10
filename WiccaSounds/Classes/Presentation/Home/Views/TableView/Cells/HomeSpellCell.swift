//
//  HomeSpellCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.03.2023.
//

import UIKit

final class HomeSpellCell: UITableViewCell {
    var didTapMoreDetails: ((Spell) -> Void)?
    
    lazy var nameLabel = makeLabel(numberOfLines: 0)
    lazy var contentLabel = makeLabel(numberOfLines: 3)
    lazy var button = makeButton()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.bold(size: 18.scale))
        .lineHeight(21.6.scale)
        .textAlignment(.left)
    private lazy var contentAttrs = TextAttributes()
        .textColor(Appearance.white.withAlphaComponent(0.7))
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
    private var spell: Spell?
    
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
extension HomeSpellCell {
    func setup(element: Spell) {
        self.spell = element
        
        let name = String(format: "Home.Today.SpellName".localized, element.name)
        nameLabel.attributedText = name.attributed(with: nameAttrs)
        
        let content = content(from: element.blocks)
        contentLabel.attributedText = content.attributed(with: contentAttrs)
    }
}

// MARK: Private
private extension HomeSpellCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    func content(from blocks: [ContentBlock]) -> String {
        var result: String = ""
        
        for block in blocks {
            guard case let .text(text) = block.content else {
                continue
            }
            
            result = text
            break
        }
        
        return result
    }
    
    @objc
    func didTapButton() {
        guard let spell = spell else {
            return
        }
        
        didTapMoreDetails?(spell)
    }
}

// MARK: Make constraints
private extension HomeSpellCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            contentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 58.scale),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -58.scale),
            button.heightAnchor.constraint(equalToConstant: 47.scale),
            button.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 16.scale),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeSpellCell {
    func makeLabel(numberOfLines: Int) -> UILabel {
        let view = UILabel()
        view.numberOfLines = numberOfLines
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Home.Today.MoreDetails".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.primary
        view.layer.cornerRadius = 23.scale
        view.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

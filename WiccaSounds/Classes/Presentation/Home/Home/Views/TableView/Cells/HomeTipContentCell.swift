//
//  HomeTipContentCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 29.03.2023.
//

import UIKit

final class HomeTipContentCell: UITableViewCell {
    lazy var titleLabel = makeLabel()
    lazy var contentLabel = makeLabel()
    
    private lazy var titleAttrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.semiBold(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    private lazy var contentAttrs = TextAttributes()
        .textColor(Appearance.white.withAlphaComponent(0.7))
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(24.scale)
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
extension HomeTipContentCell {
    func setup(tip: LunarTip) {
        titleLabel.attributedText = tip.tag.attributed(with: titleAttrs)
        contentLabel.attributedText = content(from: tip.blocks).attributed(with: contentAttrs)
    }
}

// MARK: Private
private extension HomeTipContentCell {
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
}

// MARK: Make constraints
private extension HomeTipContentCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeTipContentCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

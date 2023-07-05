//
//  TarotTextCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit

final class TarotTextCell: UITableViewCell {
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.white.withAlphaComponent(0.8))
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(24.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initiaize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TarotTextCell {
    func setup(element: String) {
        label.attributedText = element.attributed(with: attrs)
    }
}

// MARK: Private
private extension TarotTextCell {
    func initiaize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension TarotTextCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TarotTextCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

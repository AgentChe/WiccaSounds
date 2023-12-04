//
//  ContentTextCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 23.03.2023.
//

import UIKit

final class ContentTextCell: UITableViewCell {
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.white.withAlphaComponent(0.8))
        .font(Fonts.Inter.regular(size: 17.scale))
        .lineHeight(25.5.scale)
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
extension ContentTextCell {
    func setup(element: String) {
        label.attributedText = element.attributed(with: attrs)
    }
}

// MARK: Private
private extension ContentTextCell {
    func initiaize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ContentTextCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.scale),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ContentTextCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

//
//  PaygateInfoCell.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import UIKit

final class PaygateInfoCell: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.regular(size: 17.scale))
        .lineHeight(23.8.scale)
        .letterSpacing(0.17.scale)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PaygateInfoCell {
    func setup(text: String) {
        label.attributedText = text.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension PaygateInfoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 18.scale),
            imageView.heightAnchor.constraint(equalToConstant: 24.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 1.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 46.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22.scale),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateInfoCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Paygate.Star")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

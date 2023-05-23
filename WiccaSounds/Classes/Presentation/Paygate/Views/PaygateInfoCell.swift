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
        .font(Fonts.PlayfairDisplay.regular(size: ScreenSize.isIphoneXFamily ? 17.scale : 15.scale))
        .lineHeight(ScreenSize.isIphoneXFamily ? 23.8.scale : 21.scale)
        .letterSpacing(0.17.scale)
    private lazy var smallAttrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.PlayfairDisplay.regular(size: ScreenSize.isIphoneXFamily ? 15.scale : 13.scale))
        .lineHeight(ScreenSize.isIphoneXFamily ? 21.scale : 18.2.scale)
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
    func setup(text: String, isSmall: Bool = false) {
        label.attributedText = text.attributed(with: isSmall ? smallAttrs : attrs)
    }
}

// MARK: Make constraints
private extension PaygateInfoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 20.scale),
            imageView.heightAnchor.constraint(equalToConstant: 19.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
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
        view.image = UIImage(named: "Paygate.Checked")
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

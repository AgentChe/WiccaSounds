//
//  PaygateBestOfferView.swift
//  LocationTracker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import UIKit

final class PaygateBestOfferView: UIView {
    lazy var label = makeLabel()
    
    private lazy var selectedAttrs = TextAttributes()
        .textColor(Appearance.background)
        .font(Fonts.Inter.medium(size: 12.scale))
        .lineHeight(19.2.scale)
        .textAlignment(.center)
    private lazy var deselectedAttrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.medium(size: 12.scale))
        .lineHeight(19.2.scale)
        .textAlignment(.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PaygateBestOfferView {
    func update(marked: Bool) {
        let attrs = marked ? selectedAttrs : deselectedAttrs
        label.attributedText = "Paygate.BestOffer".localized.attributed(with: attrs)
        
        backgroundColor = marked ? Appearance.second : UIColor(integralRed: 20, green: 19, blue: 16)
        
        layer.borderWidth = 1.scale
        layer.borderColor = marked ? Appearance.second.cgColor : Appearance.white.withAlphaComponent(0.1).cgColor
    }
}

// MARK: Make constraints
private extension PaygateBestOfferView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 3.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateBestOfferView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

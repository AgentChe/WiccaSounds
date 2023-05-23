//
//  PaygateProductButton.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import UIKit

final class PaygateProductButton: UIButton {
    var price: ProductPrice? {
        didSet {
            update()
        }
    }
    
    lazy var label = makeLabel()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.PlayfairDisplay.regular(size: 17.scale))
        .lineHeight(23.8.scale)
        .textAlignment(.center)
        .letterSpacing(0.17.scale)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension PaygateProductButton {
    func update() {
        guard let price = price else {
            return
        }
        
        switch price.id {
        case GlobalDefinitions.Paygate.defaultLifetime:
            let string = String(format: "Paygate.Lifetime".localized, price.priceLocalized)
            label.attributedText = string.attributed(with: attrs)
        case GlobalDefinitions.Paygate.defaultMonthly:
            let string = String(format: "Paygate.Monthly".localized, price.priceLocalized)
            label.attributedText = string.attributed(with: attrs)
        default:
            return
        }
    }
}

// MARK: Make constraints
private extension PaygateProductButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateProductButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

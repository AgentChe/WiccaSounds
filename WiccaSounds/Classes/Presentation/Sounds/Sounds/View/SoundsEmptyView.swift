//
//  SoundsEmptyView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 28.04.2023.
//

import UIKit

final class SoundsEmptyView: UIView {
    lazy var label = makeLabel()
    lazy var addButton = makeAddButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension SoundsEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50.scale),
            label.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 102.scale),
            addButton.heightAnchor.constraint(equalToConstant: 102.scale),
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SoundsEmptyView {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 142, green: 142, blue: 147, alpha: 0.7))
            .font(Fonts.Inter.regular(size: 20.scale))
            .lineHeight(30.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Sounds.Empty.Placeholder".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAddButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Sounds.Empty.Add"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

//
//  PracticeUnitView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit

final class PracticeUnitView: UIView {
    enum Unit {
        case tarot, runes
    }
    
    lazy var tarotButton = makeButton(title: "Practice.Tarot".localized)
    lazy var runesButton = makeButton(title: "Practice.Runes".localized)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PracticeUnitView {
    func setup(unit: Unit) {
        tarotButton.backgroundColor = unit == .tarot ? Appearance.primary : UIColor.clear
        runesButton.backgroundColor = unit == .runes ? Appearance.primary : UIColor.clear
    }
}

// MARK: Make constraints
private extension PracticeUnitView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tarotButton.widthAnchor.constraint(equalToConstant: 77.scale),
            tarotButton.heightAnchor.constraint(equalToConstant: 36.scale),
            tarotButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            tarotButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            runesButton.widthAnchor.constraint(equalToConstant: 77.scale),
            runesButton.heightAnchor.constraint(equalToConstant: 36.scale),
            runesButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            runesButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 97.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PracticeUnitView {
    func makeButton(title: String) -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.regular(size: 18.scale))
        
        let view = UIButton()
        view.setAttributedTitle(title.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 18.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

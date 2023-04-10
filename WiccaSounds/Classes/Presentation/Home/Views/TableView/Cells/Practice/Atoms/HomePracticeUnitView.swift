//
//  HomePracticeUnitView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 29.03.2023.
//

import UIKit

final class HomePracticeUnitView: UIView {
    enum Unit {
        case tarot, runes
    }
    
    lazy var unit = Unit.tarot {
        didSet {
            update(animate: true)
        }
    }
    
    lazy var selector = makeSelector()
    lazy var tarotButton = makeButton(title: "Home.Practice.Unit.Tarot".localized)
    lazy var runesButton = makeButton(title: "Home.Practice.Unit.Runes".localized)
    
    private lazy var selectorLeadingConstraint = NSLayoutConstraint()
    private lazy var selectorTrailingConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        update(animate: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension HomePracticeUnitView {
    func update(animate: Bool) {
        NSLayoutConstraint.deactivate([
            selectorLeadingConstraint,
            selectorTrailingConstraint
        ])
        
        switch unit {
        case .tarot:
            selectorLeadingConstraint = selector.leadingAnchor.constraint(equalTo: leadingAnchor)
            selectorTrailingConstraint = selector.trailingAnchor.constraint(equalTo: centerXAnchor)
        case .runes:
            selectorLeadingConstraint = selector.leadingAnchor.constraint(equalTo: centerXAnchor)
            selectorTrailingConstraint = selector.trailingAnchor.constraint(equalTo: trailingAnchor)
        }
        
        NSLayoutConstraint.activate([
            selectorLeadingConstraint,
            selectorTrailingConstraint
        ])
        
        if animate {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.layoutIfNeeded()
            })
        } else {
            layoutIfNeeded()
        }
    }
}

// MARK: Make constraints
private extension HomePracticeUnitView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            selector.topAnchor.constraint(equalTo: topAnchor),
            selector.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tarotButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            tarotButton.trailingAnchor.constraint(equalTo: centerXAnchor),
            tarotButton.topAnchor.constraint(equalTo: topAnchor),
            tarotButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            runesButton.leadingAnchor.constraint(equalTo: centerXAnchor),
            runesButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            runesButton.topAnchor.constraint(equalTo: topAnchor),
            runesButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension HomePracticeUnitView {
    func makeSelector() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = Appearance.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton(title: String) -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.regular(size: 16.scale))
        
        let view = UIButton()
        view.setAttributedTitle(title.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

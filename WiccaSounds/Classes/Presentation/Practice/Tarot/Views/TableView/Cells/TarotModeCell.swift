//
//  TarotModeCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit

final class TarotModeCell: UITableViewCell {
    enum Mode {
        case upright, reversed
    }
    
    var didSelect: ((Mode) -> Void)?
    
    lazy var container = makeContainer()
    lazy var selector = makeSelector()
    lazy var uprightButton = makeButton(title: "Tarot.Upright".localized)
    lazy var reversedButton = makeButton(title: "Tarot.Reversed".localized)
    
    private lazy var selectorLeadingConstraint = NSLayoutConstraint()
    private lazy var selectorTrailingConstraint = NSLayoutConstraint()
    
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
extension TarotModeCell {
    func setup(mode: Mode) {
        update(mode: mode)
    }
}

// MARK: Private
private extension TarotModeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func didTap(sender: UIButton) {
        var mode: Mode?
        
        if sender === uprightButton {
            mode = .upright
        }
        
        if sender === reversedButton {
            mode = .reversed
        }
        
        guard let mode = mode else {
            return
        }
        
        update(mode: mode, animate: true) { [weak self] in
            self?.didSelect?(mode)
        }
    }
    
    func update(mode: Mode, animate: Bool = false, completion: (() -> Void)? = nil) {
        NSLayoutConstraint.deactivate([
            selectorLeadingConstraint,
            selectorTrailingConstraint
        ])
        
        switch mode {
        case .upright:
            selectorLeadingConstraint = selector.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 2.scale)
            selectorTrailingConstraint = selector.trailingAnchor.constraint(equalTo: container.centerXAnchor, constant: -2.scale)
        case .reversed:
            selectorLeadingConstraint = selector.leadingAnchor.constraint(equalTo: container.centerXAnchor, constant: 2.scale)
            selectorTrailingConstraint = selector.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -2.scale)
        }
        
        NSLayoutConstraint.activate([
            selectorLeadingConstraint,
            selectorTrailingConstraint
        ])
        
        if animate {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.layoutIfNeeded()
            }, completion: { result in
                completion?()
            })
        } else {
            layoutIfNeeded()
            completion?()
        }
    }
}

// MARK: Make constraints
private extension TarotModeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 34.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -34.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13.scale),
            container.heightAnchor.constraint(equalToConstant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            selector.topAnchor.constraint(equalTo: container.topAnchor, constant: 2.scale),
            selector.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            uprightButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            uprightButton.trailingAnchor.constraint(equalTo: container.centerXAnchor),
            uprightButton.topAnchor.constraint(equalTo: container.topAnchor),
            uprightButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            reversedButton.leadingAnchor.constraint(equalTo: container.centerXAnchor),
            reversedButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            reversedButton.topAnchor.constraint(equalTo: container.topAnchor),
            reversedButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TarotModeCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = Appearance.white.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSelector() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = Appearance.primary
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
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
        view.addTarget(self, action: #selector(didTap(sender:)), for: .touchUpInside)
        container.addSubview(view)
        return view
    }
}

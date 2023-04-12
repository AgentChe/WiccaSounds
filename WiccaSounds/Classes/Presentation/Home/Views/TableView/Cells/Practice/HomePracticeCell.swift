//
//  HomePracticeCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 29.03.2023.
//

import UIKit

final class HomePracticeCell: UITableViewCell {
    var didOpenTarot: ((TarotCover) -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var unitView = makeUnitView()
    lazy var tarotView = makeTarotView()
    lazy var runesView = makeRunesView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
        updateVisibleUnit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomePracticeCell {
    func setup(
        element: HomePracticeElement,
        didOpenTarot: @escaping ((TarotOnDay) -> Void),
        didShowTarot: @escaping ((TarotCover) -> Void),
        didOpenRune: @escaping ((RuneOnDay) -> Void),
        didShowRune: @escaping ((RuneCover) -> Void)
    ) {
        tarotView.setup(tarotOnToday: element.tarotOnToday)
        tarotView.didOpenTarot = didOpenTarot
        tarotView.didShowTarot = didShowTarot
        
        runesView.setup(runeOnToday: element.runeOnToday)
        runesView.didOpenRune = didOpenRune
        runesView.didShowRune = didShowRune
    }
}

// MARK: Private
private extension HomePracticeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func didTapUnit(sender: UIButton) {
        if sender === unitView.tarotButton {
            unitView.unit = .tarot
        }
        
        if sender === unitView.runesButton {
            unitView.unit = .runes
        }
        
        updateVisibleUnit()
    }
    
    func updateVisibleUnit() {
        tarotView.isHidden = unitView.unit != .tarot
        runesView.isHidden = unitView.unit != .runes
    }
}

// MARK: Make constraints
private extension HomePracticeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            unitView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            unitView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            unitView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale),
            unitView.heightAnchor.constraint(equalToConstant: 40.scale),
            unitView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -498.scale)
        ])
        
        NSLayoutConstraint.activate([
            tarotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tarotView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tarotView.topAnchor.constraint(equalTo: unitView.bottomAnchor, constant: 24.scale),
            tarotView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.scale)
        ])
        
        NSLayoutConstraint.activate([
            runesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            runesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            runesView.topAnchor.constraint(equalTo: unitView.bottomAnchor, constant: 24.scale),
            runesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension HomePracticeCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.bold(size: 18.scale))
            .lineHeight(21.6.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Home.Practice.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeUnitView() -> HomePracticeUnitView {
        let view = HomePracticeUnitView()
        view.backgroundColor = UIColor(integralRed: 70, green: 67, blue: 57)
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.tarotButton.addTarget(self, action: #selector(didTapUnit(sender:)), for: .touchUpInside)
        view.runesButton.addTarget(self, action: #selector(didTapUnit(sender:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTarotView() -> HomePracticeTarotView {
        let view = HomePracticeTarotView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeRunesView() -> HomePracticeRuneView {
        let view = HomePracticeRuneView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

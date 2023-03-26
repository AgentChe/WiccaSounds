//
//  HomeLunarCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.03.2023.
//

import UIKit

final class HomeLunarCell: UITableViewCell {
    lazy var titleLabel = makeTitleLabel()
    lazy var containerView = makeContainerView()
    lazy var largeOffsetView = makeImageView()
    lazy var phaseLabel = makeLabel()
    lazy var illuminationLabel = makeLabel()
    lazy var separator = makeSeparator()
    lazy var stackView = makeStackView()
    lazy var day1View = makeDayView()
    lazy var day2View = makeDayView()
    lazy var day3View = makeDayView()
    lazy var day4View = makeDayView()
    lazy var day5View = makeDayView()
    lazy var day6View = makeDayView()
    lazy var day7View = makeDayView()
    
    private lazy var fieldTitleAttrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.semiBold(size: 16.scale))
        .lineHeight(19.2.scale)
        .textAlignment(.left)
    private lazy var fieldValueAttrs = TextAttributes()
        .textColor(Appearance.white.withAlphaComponent(0.8))
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(19.2.scale)
        .textAlignment(.left)
    
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
extension HomeLunarCell {
    func setup(element: Lunar) {
        let largeShadowOffsetImageName = "Home.Lunar.Large.Offset.\(element.shadowOffset)"
        largeOffsetView.image = UIImage(named: largeShadowOffsetImageName)
        
        let phase = NSMutableAttributedString()
        phase.append("Home.Lunar.Phase".localized.attributed(with: fieldTitleAttrs))
        phase.append(element.phase.attributed(with: fieldValueAttrs))
        phaseLabel.attributedText = phase
        
        let illumination = NSMutableAttributedString()
        illumination.append("Home.Lunar.Illumination".localized.attributed(with: fieldTitleAttrs))
        illumination.append(String(format: "%i%%", element.illumination).attributed(with: fieldValueAttrs))
        illuminationLabel.attributedText = illumination
        
        let dayViews = [
            day1View, day2View, day3View, day4View, day5View, day6View, day7View
        ]
        dayViews.forEach { $0.isHidden = true }
        for (index, day) in element.days.prefix(7).enumerated() {
            dayViews[index].isHidden = false
            dayViews[index].day = day
        }
    }
}

// MARK: Private
private extension HomeLunarCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension HomeLunarCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.scale),
            containerView.heightAnchor.constraint(equalToConstant: 190.scale)
        ])
        
        NSLayoutConstraint.activate([
            largeOffsetView.widthAnchor.constraint(equalToConstant: 80.scale),
            largeOffsetView.heightAnchor.constraint(equalToConstant: 80.scale),
            largeOffsetView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.scale),
            largeOffsetView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            phaseLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 107.scale),
            phaseLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.scale),
            phaseLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            illuminationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 107.scale),
            illuminationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.scale),
            illuminationLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 61.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.scale),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 112.scale)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15.scale),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15.scale),
            stackView.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 16.scale),
            stackView.heightAnchor.constraint(equalToConstant: 46.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeLunarCell {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.bold(size: 18.scale))
            .lineHeight(21.6.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Home.Lunar.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeContainerView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Home.Lunar")
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.white.withAlphaComponent(0.15).cgColor
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.white.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 8.scale
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeDayView() -> LunarDayView {
        let view = LunarDayView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(view)
        return view
    }
}

//
//  ExploreFilterItem.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import UIKit

final class ExploreFilterItem: UIButton {
    lazy var marked = false {
        didSet {
            changeMarked()
        }
    }
    
    let filter: ExploreFilterView.Filter
    
    lazy var label = makeLabel()
    
    init(filter: ExploreFilterView.Filter) {
        self.filter = filter
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ExploreFilterItem {
    func changeMarked() {
        backgroundColor = marked ? Appearance.primary : UIColor.clear
    }
    
    func title() -> String {
        switch filter {
        case .spells:
            return "Explore.Filter.Spells".localized
        case .candles:
            return "Explore.Filter.Candles".localized
        case .herbs:
            return "Explore.Filter.Herbs".localized
        case .crystals:
            return "Explore.Filter.Crystals".localized
        }
    }
}

// MARK: Make constraints
private extension ExploreFilterItem {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ExploreFilterItem {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.regular(size: 18.scale))
            .lineHeight(21.6.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = title().attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

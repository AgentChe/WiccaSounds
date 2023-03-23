//
//  ExploreFilterView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import UIKit

final class ExploreFilterView: UIView {
    enum Filter {
        case spells, candles, herbs, crystals
    }
    
    lazy var filter = Filter.spells {
        didSet {
            changeFilter()
        }
    }
    
    lazy var scrollView = makeScrollView()
    lazy var spellsItem = makeItem(filter: .spells)
    lazy var candlesItem = makeItem(filter: .candles)
    lazy var herbsItem = makeItem(filter: .herbs)
    lazy var crystalsItem = makeItem(filter: .crystals)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        changeFilter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ExploreFilterView {
    func changeFilter() {
        spellsItem.marked = filter == .spells
        candlesItem.marked = filter == .candles
        herbsItem.marked = filter == .herbs
        crystalsItem.marked = filter == .crystals
    }
}

// MARK: Make constraints
private extension ExploreFilterView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            spellsItem.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            spellsItem.topAnchor.constraint(equalTo: scrollView.topAnchor),
            spellsItem.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            candlesItem.leadingAnchor.constraint(equalTo: spellsItem.trailingAnchor, constant: 4.scale),
            candlesItem.topAnchor.constraint(equalTo: scrollView.topAnchor),
            candlesItem.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            herbsItem.leadingAnchor.constraint(equalTo: candlesItem.trailingAnchor, constant: 4.scale),
            herbsItem.topAnchor.constraint(equalTo: scrollView.topAnchor),
            herbsItem.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            crystalsItem.leadingAnchor.constraint(equalTo: herbsItem.trailingAnchor, constant: 4.scale),
            crystalsItem.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            crystalsItem.topAnchor.constraint(equalTo: scrollView.topAnchor),
            crystalsItem.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ExploreFilterView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeItem(filter: Filter) -> ExploreFilterItem {
        let view = ExploreFilterItem(filter: filter)
        view.layer.cornerRadius = 18.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
}

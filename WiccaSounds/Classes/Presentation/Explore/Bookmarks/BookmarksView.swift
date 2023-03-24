//
//  BookmarksView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.03.2023.
//

import UIKit

final class BookmarksView: UIView {
    lazy var filterView = makeFilterView()
    lazy var tableView = makeTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension BookmarksView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension BookmarksView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            filterView.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 9.scale),
            filterView.heightAnchor.constraint(equalToConstant: 38.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BookmarksView {
    func makeFilterView() -> ExploreFilterView {
        let view = ExploreFilterView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> ExploreTableView {
        let view = ExploreTableView (frame: .zero, style: .insetGrouped)
        view.contentInset = UIEdgeInsets(top: 16.scale, left: 0, bottom: 12.scale, right: 0)
        view.setContentOffset(CGPoint(x: 0, y: -16.scale), animated: false)
        view.separatorStyle = .none
        view.layoutMargins = UIEdgeInsets(top: 8.scale, left: 16.scale, bottom: 8.scale, right: 16.scale)
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0
        }
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

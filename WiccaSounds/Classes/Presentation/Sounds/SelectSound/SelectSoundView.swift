//
//  SelectSoundView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 27.04.2023.
//

import UIKit

final class SelectSoundView: UIView {
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
private extension SelectSoundView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension SelectSoundView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SelectSoundView {
    func makeTableView() -> SelectSoundTableView {
        let view = SelectSoundTableView ()
        view.contentInset = UIEdgeInsets.zero
        view.setContentOffset(CGPoint.zero, animated: false)
        view.separatorStyle = .none
        view.layoutMargins = UIEdgeInsets.zero
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

//
//  SoundsView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 28.04.2023.
//

import UIKit

final class SoundsView: UIView {
    lazy var viewportView = makeViewportView()
    lazy var emptyView = makeEmptyView()
    
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
private extension SoundsView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension SoundsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            viewportView.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewportView.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewportView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            viewportView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SoundsView {
    func makeViewportView() -> ViewportView {
        let view = ViewportView()
        view.backgroundColor = Appearance.background
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> SoundsEmptyView {
        let view = SoundsEmptyView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

//
//  ViewportTitleView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 27.04.2023.
//

import UIKit

final class ViewportTitleView: UIView {
    lazy var addButton = makeAddButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension ViewportTitleView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 24.scale),
            addButton.heightAnchor.constraint(equalToConstant: 24.scale),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ViewportTitleView {
    func makeAddButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Sounds.Add"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

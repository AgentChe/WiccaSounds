//
//  TabPlayPauseView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 28.04.2023.
//

import UIKit

final class TabPlayPauseView: UIView {
    lazy var playPauseButton = makePlayPauseButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension TabPlayPauseView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            playPauseButton.widthAnchor.constraint(equalToConstant: 24.scale),
            playPauseButton.heightAnchor.constraint(equalToConstant: 24.scale),
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: topAnchor, constant: 15.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TabPlayPauseView {
    func makePlayPauseButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

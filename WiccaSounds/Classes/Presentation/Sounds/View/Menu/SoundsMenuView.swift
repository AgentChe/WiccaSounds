//
//  SoundsMenuView.swift
//  SleepWell
//
//  Created by Andrey Chernyshev on 28/01/2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class SoundsMenuView: UIView {
    lazy var sleepTimerButton = makeSleepTimerButton()
    lazy var clearAllButton = makeClearAllButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension SoundsMenuView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            sleepTimerButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            sleepTimerButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            sleepTimerButton.topAnchor.constraint(equalTo: topAnchor),
            sleepTimerButton.heightAnchor.constraint(equalToConstant: 62.5.scale)
        ])
        
        NSLayoutConstraint.activate([
            clearAllButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            clearAllButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            clearAllButton.topAnchor.constraint(equalTo: sleepTimerButton.bottomAnchor),
            clearAllButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            clearAllButton.heightAnchor.constraint(equalToConstant: 62.5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SoundsMenuView {
    func makeSleepTimerButton() -> SoundsMenuButton {
        let view = SoundsMenuButton(
            iconName: "Sounds.SleepTimer",
            title: "Sounds.SleepTimer".localized
        )
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeClearAllButton() -> SoundsMenuButton {
        let view = SoundsMenuButton(
            iconName: "Sounds.ClearAll",
            title: "Sounds.ClearAll".localized
        )
        view.separator.isHidden = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

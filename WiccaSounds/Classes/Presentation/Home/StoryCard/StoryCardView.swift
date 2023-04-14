//
//  StoryCardView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 25.10.2022.
//

import UIKit

final class StoryCardView: UIView {
    lazy var stepsView = makeStepsView()
    lazy var closeButton = makeCloseButton()
    lazy var tableView = makeTableView()
    lazy var previousButton = makeNavigationButton()
    lazy var nextButton = makeNavigationButton()
    lazy var preloader = makePreloader()
    
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
private extension StoryCardView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension StoryCardView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stepsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepsView.topAnchor.constraint(equalTo: topAnchor, constant: 9.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            previousButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 12.scale),
            previousButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            previousButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            previousButton.widthAnchor.constraint(equalToConstant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 12.scale),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension StoryCardView {
    func makeStepsView() -> StoryCardStepsView {
        let view = StoryCardStepsView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "StoryCard.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> StoryCardTableView {
        let view = StoryCardTableView()
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 30.scale, left: 0, bottom: 16.scale, right: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNavigationButton() -> UIButton {
        let view = UIButton()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

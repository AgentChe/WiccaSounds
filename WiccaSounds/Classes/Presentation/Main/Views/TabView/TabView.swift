//
//  TabView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case home, explore, practice, ambience
    }
    
    lazy var stackView = makeStackView()
    lazy var homeItem = makeItem(code: "Main.Tab.Home")
    lazy var exploreItem = makeItem(code: "Main.Tab.Explore")
    lazy var practiceItem = makeItem(code: "Main.Tab.Practice")
    lazy var ambienceItem = makeItem(code: "Main.Tab.Ambience")
    lazy var playPauseView = makePlayPauseView()
    
    var selectedTab = Tab.home {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        draw(with: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TabView {
    func draw(with playPause: Bool) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        stackView.addArrangedSubview(homeItem)
        stackView.addArrangedSubview(exploreItem)
        stackView.addArrangedSubview(practiceItem)
        stackView.addArrangedSubview(ambienceItem)
        
        playPauseView.isHidden = !playPause
        if playPause {
            stackView.addArrangedSubview(playPauseView)
        }
    }
    
    func updatePlauPauseButton(isPlaying: Bool) {
        let image = UIImage(named: isPlaying ? "Main.Tab.Pause" : "Main.Tab.Play")
        playPauseView.playPauseButton.setImage(image, for: .normal)
    }
}

// MARK: Private
private extension TabView {
    func update() {
        homeItem.marked = selectedTab == .home
        exploreItem.marked = selectedTab == .explore
        practiceItem.marked = selectedTab == .practice
        ambienceItem.marked = selectedTab == .ambience
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 0
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeItem(code: String) -> TabItemView {
        let view = TabItemView(code: code)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePlayPauseView() -> TabPlayPauseView {
        let view = TabPlayPauseView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

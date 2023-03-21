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
    
    lazy var homeItem = makeItem(code: "Main.Tab.Home")
    lazy var exploreItem = makeItem(code: "Main.Tab.Explore")
    lazy var practiceItem = makeItem(code: "Main.Tab.Practice")
    lazy var ambienceItem = makeItem(code: "Main.Tab.Ambience")
    
    var selectedTab = Tab.home {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            homeItem.leadingAnchor.constraint(equalTo: leadingAnchor),
            homeItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            homeItem.topAnchor.constraint(equalTo: topAnchor),
            homeItem.widthAnchor.constraint(equalTo: exploreItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            exploreItem.leadingAnchor.constraint(equalTo: homeItem.trailingAnchor),
            exploreItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            exploreItem.topAnchor.constraint(equalTo: topAnchor),
            exploreItem.widthAnchor.constraint(equalTo: practiceItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            practiceItem.leadingAnchor.constraint(equalTo: exploreItem.trailingAnchor),
            practiceItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            practiceItem.topAnchor.constraint(equalTo: topAnchor),
            practiceItem.widthAnchor.constraint(equalTo: ambienceItem.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ambienceItem.leadingAnchor.constraint(equalTo: practiceItem.trailingAnchor),
            ambienceItem.bottomAnchor.constraint(equalTo: bottomAnchor),
            ambienceItem.topAnchor.constraint(equalTo: topAnchor),
            ambienceItem.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeItem(code: String) -> TabItemView {
        let view = TabItemView(code: code)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

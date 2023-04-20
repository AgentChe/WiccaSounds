//
//  PracticeView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit

final class PracticeView: UIView {
    lazy var unitView = makeUnitView()
    lazy var collectionView = makeCollectionView()
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
private extension PracticeView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension PracticeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            unitView.leadingAnchor.constraint(equalTo: leadingAnchor),
            unitView.trailingAnchor.constraint(equalTo: trailingAnchor),
            unitView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 9.scale),
            unitView.heightAnchor.constraint(equalToConstant: 36.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: unitView.bottomAnchor, constant: 2.scale),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PracticeView {
    func makeUnitView() -> PracticeUnitView {
        let view = PracticeUnitView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> PracticeCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16.scale
        layout.minimumInteritemSpacing = 16.scale
        
        let view = PracticeCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(top: 16.scale, left: 16.scale, bottom: 16.scale, right: 16.scale)
        view.showsHorizontalScrollIndicator = false
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

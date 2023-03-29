//
//  HomeTipsCollectionView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 29.03.2023.
//

import UIKit

final class HomeTipsCollectionView: UICollectionView {
    private lazy var elements = [HomeTipElement]()
    
    private var tapped: ((HomeTipElement) -> Void)?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomeTipsCollectionView {
    func setup(elements: [HomeTipElement], tapped: @escaping (HomeTipElement) -> Void) {
        self.elements = elements
        self.tapped = tapped
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension HomeTipsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: HomeTipsCollectionCell.self), for: indexPath) as! HomeTipsCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeTipsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 48.scale, height: 48.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        tapped?(element)
    }
}

// MARK: Private
private extension HomeTipsCollectionView {
    func initialize() {
        register(HomeTipsCollectionCell.self, forCellWithReuseIdentifier: String(describing: HomeTipsCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}

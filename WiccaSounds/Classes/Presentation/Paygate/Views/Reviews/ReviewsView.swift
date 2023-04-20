//
//  ReviewsView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 19.04.2023.
//

import UIKit

final class ReviewsView: UICollectionView {
    private lazy var elements = ReviewElement.makeCollection()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UICollectionViewDataSource
extension ReviewsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1000000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ReviewCell.self), for: indexPath) as! ReviewCell
        cell.setup(element: elements[indexPath.row % elements.count])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ReviewsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 249.scale, height: ScreenSize.isIphoneXFamily ? 136.scale : 118.scale)
    }
}

// MARK: Private
private extension ReviewsView {
    func initialize() {
        register(ReviewCell.self, forCellWithReuseIdentifier: String(describing: ReviewCell.self))
        
        dataSource = self
        delegate = self
    }
}

//
//  PracticeCollectionView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit

protocol PracticeCollectionDelegate: AnyObject {
    func practiceDidTap(element: PracticeTarotElement)
    func practiceDidTap(element: PracticeRuneElement)
}

final class PracticeCollectionView: UICollectionView {
    weak var mainDelegate: PracticeCollectionDelegate?
    
    lazy var elements = [PracticeCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PracticeCollectionView {
    func setup(elements: [PracticeCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension PracticeCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .tarot(let element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: PracticeTarotCell.self), for: indexPath) as! PracticeTarotCell
            cell.setup(element: element)
            return cell
        case .rune(let element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: PracticeRuneCell.self), for: indexPath) as! PracticeRuneCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PracticeCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch elements[indexPath.row] {
        case .tarot:
            return CGSize(width: 103.scale, height: 266.scale)
        case .rune:
            return CGSize(width: 103.scale, height: 173.scale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .tarot(let element):
            mainDelegate?.practiceDidTap(element: element)
        case .rune(let element):
            mainDelegate?.practiceDidTap(element: element)
        }
    }
}

// MARK: Private
private extension PracticeCollectionView {
    func initialize() {
        register(PracticeTarotCell.self, forCellWithReuseIdentifier: String(describing: PracticeTarotCell.self))
        register(PracticeRuneCell.self, forCellWithReuseIdentifier: String(describing: PracticeRuneCell.self))
        
        dataSource = self
        delegate = self
    }
}

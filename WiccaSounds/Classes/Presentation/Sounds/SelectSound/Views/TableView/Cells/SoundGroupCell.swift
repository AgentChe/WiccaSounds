//
//  SoundGroupCell.swift
//  SleepWell
//
//  Created by Vitaliy Zagorodnov on 04/01/2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class SoundGroupCell: UITableViewCell {
    lazy var titleLabel = makeLabel()
    lazy var collectionView = makeCollectionView()
    
    private var selectedItem: ((SoundCellElement) -> Void)?
    
    private lazy var elements: [SoundCellElement] = []
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.bold(size: 18.scale))
        .lineHeight(21.6.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SoundGroupCell {
    func setup(model: NoiseCategory, isActiveSubscription: Bool, closure: @escaping ((SoundCellElement) -> Void)) {
        self.selectedItem = closure
        
        titleLabel.attributedText = model.name.attributed(with: attrs)
        
        elements = SoundCellElement.map(
            noises: model.noises.sorted(by: { $0.sort < $1.sort }),
            isActiveSubscription: isActiveSubscription
        )
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension SoundGroupCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let element = elements[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SoundCell.self), for: indexPath) as! SoundCell
        cell.setup(image: element.noise.imageUrl, title: element.noise.name, isActiveSubscription: element.isActiveSubscription)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension SoundGroupCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 92.scale, height: 130.scale)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItem?(elements[indexPath.row])
    }
}

// MARK: Private
private extension SoundGroupCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SoundGroupCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.scale),
            collectionView.heightAnchor.constraint(equalToConstant: 284.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SoundGroupCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16.scale
        layout.minimumInteritemSpacing = 16.scale
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(SoundCell.self, forCellWithReuseIdentifier: String(describing: SoundCell.self))
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(top: 0, left: 16.scale, bottom: 0, right: 16.scale)
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

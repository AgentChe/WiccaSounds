//
//  RuneImageCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit
import Kingfisher

final class RuneImageCell: UITableViewCell {
    lazy var runeBackView = makeImageView()
    lazy var pictureView = makeImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pictureView.kf.cancelDownloadTask()
        pictureView.image = nil
    }
}

// MARK: Public
extension RuneImageCell {
    func setup(element: URL) {
        pictureView.kf.setImage(with: element)
    }
}

// MARK: Private
private extension RuneImageCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
        
        runeBackView.image = UIImage(named: "Rune.Background")
    }
}

// MARK: Make constraints
private extension RuneImageCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            runeBackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 88.scale),
            runeBackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -88.scale),
            runeBackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13.scale),
            runeBackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.scale),
            runeBackView.heightAnchor.constraint(equalToConstant: 293.scale)
        ])
        
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 88.scale),
            pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -88.scale),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13.scale),
            pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 293.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RuneImageCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

//
//  StoryCardImageCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 25.10.2022.
//

import UIKit
import Kingfisher

final class StoryCardImageCell: UITableViewCell {
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
extension StoryCardImageCell {
    func setup(element: URL) {
        pictureView.kf.setImage(with: element)
    }
}

// MARK: Private
private extension StoryCardImageCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension StoryCardImageCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pictureView.heightAnchor.constraint(equalToConstant: 271.scale),
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30.scale),
            pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30.scale),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.scale),
            pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension StoryCardImageCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.backgroundColor = Appearance.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.white.withAlphaComponent(0.15).cgColor
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

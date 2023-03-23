//
//  ContentImageCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 23.03.2023.
//

import UIKit
import Kingfisher

final class ContentImageCell: UITableViewCell {
    lazy var pictureView = makeImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initiaize()
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
extension ContentImageCell {
    func setup(element: URL) {
        pictureView.kf.setImage(with: element)
    }
}

// MARK: Private
private extension ContentImageCell {
    func initiaize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ContentImageCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 236.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ContentImageCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.backgroundColor = Appearance.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.white.withAlphaComponent(0.1).cgColor
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

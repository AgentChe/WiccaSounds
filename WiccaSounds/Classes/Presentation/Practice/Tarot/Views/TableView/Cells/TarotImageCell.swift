//
//  TarotImageCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit
import Kingfisher

final class TarotImageCell: UITableViewCell {
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
extension TarotImageCell {
    func setup(element: TarotImageElement) {
        pictureView.kf.setImage(with: element.image)
        
        switch element.mode {
        case .upright:
            pictureView.transform =  CGAffineTransform.identity
        case .reversed:
            pictureView.transform =  CGAffineTransform(rotationAngle: .pi)
        }
    }
}

// MARK: Private
private extension TarotImageCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension TarotImageCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 92.scale),
            pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -92.scale),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13.scale),
            pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 376.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TarotImageCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

//
//  ContentImageCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 23.03.2023.
//

import UIKit
import Kingfisher

final class ContentImageCell: UITableViewCell {
    lazy var gradientView = makeGradientView()
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
    func setup(element: ContentTableImage) {
        gradientView.isHidden = !element.withGradient
        
        pictureView.backgroundColor = element.withGradient ? UIColor.clear : Appearance.white.withAlphaComponent(0.1)
        pictureView.kf.setImage(with: element.url)
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
            gradientView.leadingAnchor.constraint(equalTo: pictureView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: pictureView.trailingAnchor),
            gradientView.topAnchor.constraint(equalTo: pictureView.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: pictureView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale),
            pictureView.heightAnchor.constraint(equalToConstant: 236.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ContentImageCell {
    func makeGradientView() -> GradientView {
        let view = GradientView()
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.colors = [
            UIColor(integralRed: 63, green: 61, blue: 101).cgColor,
            UIColor(integralRed: 29, green: 28, blue: 25).cgColor
        ]
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.white.withAlphaComponent(0.15).cgColor
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

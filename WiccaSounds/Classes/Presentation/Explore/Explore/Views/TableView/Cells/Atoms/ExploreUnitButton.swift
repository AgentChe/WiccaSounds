//
//  ExploreUnitButton.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 23.03.2023.
//

import UIKit
import Kingfisher

final class ExploreUnitButton: UIView {
    lazy var pictureView = makeImageView()
    lazy var nameLabel = makeLabel()
    lazy var lockView = makeLockView()
    
    var element: ExploreUnitElement.Unit?
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.regular(size: 16.scale))
        .lineHeight(19.2.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ExploreUnitButton {
    func setup(element: ExploreUnitElement.Unit?) {
        self.element = element
        
        isHidden = element == nil
        
        guard let element = element else {
            return
        }
        
        pictureView.kf.cancelDownloadTask()
        pictureView.image = nil
        let imageUrl = imageUrl(at: element)
        pictureView.kf.setImage(with: imageUrl)
        
        nameLabel.attributedText = name(at: element).attributed(with: attrs)
        
        lockView.isHidden = !locked(at: element)
    }
}

// MARK: Private
private extension ExploreUnitButton {
    func imageUrl(at unit: ExploreUnitElement.Unit) -> URL {
        switch unit {
        case let .candle(candle, _):
            return candle.image
        case let .herb(herb, _):
            return herb.image
        case let .crystal(crystal, _):
            return crystal.image
        }
    }
    
    func name(at unit: ExploreUnitElement.Unit) -> String {
        switch unit {
        case let .candle(candle, _):
            return candle.name
        case let .herb(herb, _):
            return herb.name
        case let .crystal(crystal, _):
            return crystal.name
        }
    }
    
    func locked(at unit: ExploreUnitElement.Unit) -> Bool {
        switch unit {
        case let .candle(_, locked):
            return locked
        case let .herb(_, locked):
            return locked
        case let .crystal(_, locked):
            return locked
        }
    }
}

// MARK: Make constraints
private extension ExploreUnitButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pictureView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pictureView.topAnchor.constraint(equalTo: topAnchor),
            pictureView.heightAnchor.constraint(equalToConstant: 185.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: pictureView.bottomAnchor, constant: 13.scale)
        ])
        
        NSLayoutConstraint.activate([
            lockView.widthAnchor.constraint(equalToConstant: 32.scale),
            lockView.heightAnchor.constraint(equalToConstant: 32.scale),
            lockView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale),
            lockView.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ExploreUnitButton {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.white.withAlphaComponent(0.1).cgColor
        view.backgroundColor = Appearance.white.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLockView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Explore.Unit.Lock")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

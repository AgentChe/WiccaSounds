//
//  PaygateProductButton.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import UIKit

final class PaygateProductButton: UIButton {
    var isChecked: Bool = false {
        didSet {
            configure()
        }
    }
    
    var info: PaygateOptionInfo? {
        didSet {
            configure()
        }
    }
    
    lazy var headerLabel = makeLabel()
    lazy var captionLabel = makeLabel()
    lazy var saveLabel = makeSaveLabel()
    lazy var checkedView = makeCheckedView()
    
    private lazy var headerSelectedAttrs = TextAttributes()
        .textColor(Appearance.background)
        .font(Fonts.Inter.regular(size: 17.scale))
        .lineHeight(21.scale)
        .lineBreakMode(.byTruncatingTail)
    private lazy var headerNormalAttrs = TextAttributes()
        .textColor(Appearance.white.withAlphaComponent(0.8))
        .font(Fonts.Inter.regular(size: 17.scale))
        .lineHeight(21.scale)
        .lineBreakMode(.byTruncatingTail)
    private lazy var captionSelectedAttrs = TextAttributes()
        .textColor(Appearance.background)
        .font(Fonts.Inter.bold(size: 17.scale))
        .lineHeight(23.8.scale)
        .letterSpacing(0.17.scale)
        .lineBreakMode(.byTruncatingTail)
    private lazy var captionNormalAttrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.bold(size: 17.scale))
        .lineHeight(23.8.scale)
        .letterSpacing(0.17.scale)
        .lineBreakMode(.byTruncatingTail)
    private lazy var saveAttrs = TextAttributes()
        .textColor(Appearance.custom31)
        .font(Fonts.Inter.bold(size: 12.scale))
        .lineHeight(14.52.scale)
        .letterSpacing(-0.08.scale)
        .lineBreakMode(.byTruncatingTail)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension PaygateProductButton {
    func configure() {
        guard let info = info else {
            return
        }
        
        backgroundColor = isChecked ? Appearance.second : Appearance.white.withAlphaComponent(0.1)
        
        let headerAttrs = isChecked ? headerSelectedAttrs : headerNormalAttrs
        headerLabel.attributedText = info.title.attributed(with: headerAttrs)
        
        let captionAttrs = isChecked ? captionSelectedAttrs : captionNormalAttrs
        captionLabel.attributedText = info.caption.attributed(with: captionAttrs)
        
        saveLabel.isHidden = info.save == nil
        saveLabel.attributedText = info.save?.attributed(with: saveAttrs)
        
        let imageName = isChecked ? "Paygate.Checked" : "Paygate.Unchecked"
        checkedView.image = UIImage(named: imageName)
    }
}

// MARK: Make constraints
private extension PaygateProductButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -56.scale),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            captionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -56.scale),
            captionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 7.scale)
        ])
        
        NSLayoutConstraint.activate([
            saveLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            saveLabel.centerYAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 25.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 25.scale),
            checkedView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateProductButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSaveLabel() -> PaddingLabel {
        let view = PaddingLabel()
        view.insets = UIEdgeInsets(top: 2.scale, left: 4.scale, bottom: 2.scale, right: 4.scale)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 4.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

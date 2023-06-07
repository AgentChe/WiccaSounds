//
//  TagView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit

final class TagView: UIView {
    lazy var label = makeLabel()
    
    let text: String
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.white.withAlphaComponent(0.7))
        .font(Fonts.Inter.regular(size: 14.scale))
        .lineHeight(19.6.scale)
        .textAlignment(.left)
    
    init(text: String) {
        self.text = text
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        var size = textSize()
        size.height += TagsView.Constants.paddingY * 2
        size.width += TagsView.Constants.paddingX * 2
        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame.size = textSize()
        label.frame.origin = CGPoint(x: TagsView.Constants.paddingX, y: TagsView.Constants.paddingY)
    }
}

// MARK: Private
private extension TagView {
    func textSize() -> CGSize {
        let contraintWidth = TagsView.Constants.width - TagsView.Constants.paddingX * 2
        let constraintRect = CGSize(width: contraintWidth, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attrs.dictionary,
            context: nil
        )
        return boundingBox.size
    }
}

// MARK: Lazy initialization
private extension TagView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.attributedText = text.attributed(with: attrs)
        view.numberOfLines = 0
        addSubview(view)
        return view
    }
}

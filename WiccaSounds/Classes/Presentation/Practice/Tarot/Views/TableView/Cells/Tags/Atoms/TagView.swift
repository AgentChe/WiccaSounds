//
//  TagView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit

final class TagView: UIButton {
    let text: String
    
    private lazy var font = Fonts.Inter.regular(size: 14.scale)
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.white.withAlphaComponent(0.7))
        .font(font)
        .lineBreakMode(.byTruncatingMiddle)
    
    init(text: String) {
        self.text = text
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        var size = NSString(string: text).size(withAttributes: attrs.dictionary)
        size.height = font.pointSize + titleEdgeInsets.top + titleEdgeInsets.bottom
        size.width += titleEdgeInsets.left + titleEdgeInsets.right
        if size.width < size.height {
            size.width = size.height
        }
        return size
    }
}

// MARK: Private
private extension TagView {
    func initialize() {
        setAttributedTitle(text.attributed(with: attrs), for: .normal)
    }
}

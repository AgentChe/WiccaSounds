//
//  StoryCardStepsView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 25.10.2022.
//

import UIKit

final class StoryCardStepsView: UIView {
    private lazy var views = [UIView]()
    
    private lazy var position = 0
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 375.scale, height: 2.scale)
    }
}

// MARK: Public
extension StoryCardStepsView {
    func set(count: Int) {
        createViews(count: count)
        updateViewsAtPosition()
    }
    
    func set(index: Int) {
        position = index + 1
        
        updateViewsAtPosition()
    }
}

// MARK: Private
private extension StoryCardStepsView {
    func createViews(count: Int) {
        let padding = 3.scale
        
        let ignoreWidth = 18.scale * 2
        let paddingWidth = CGFloat(count - 1) * padding
        let totalWidth = intrinsicContentSize.width - ignoreWidth - paddingWidth
        let width = totalWidth / CGFloat(count)
        
        let leading = 18.scale
        
        for i in 0...(count - 1) {
            let x = leading + CGFloat(i) * (width + padding)
            
            let view = UIView()
            view.backgroundColor = Appearance.white
            view.frame.size = CGSize(width: width, height: intrinsicContentSize.height)
            view.frame.origin = CGPoint(x: x, y: 0)
            view.layer.cornerRadius = 1.scale
            addSubview(view)
            
            views.append(view)
        }
    }
    
    func updateViewsAtPosition() {
        views.enumerated().forEach { index, view in
            view.backgroundColor = Appearance.white.withAlphaComponent(index < position ? 1 : 0.2)
        }
    }
}

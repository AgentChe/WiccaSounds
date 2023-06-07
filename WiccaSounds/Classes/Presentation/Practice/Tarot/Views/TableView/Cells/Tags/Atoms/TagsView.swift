//
//  TagsView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit

final class TagsView: UIView {
    enum Constants {
        static let width = 343.scale
        static let paddingX = 12.scale
        static let paddingY = 6.scale
        static let marginX = 8.scale
        static let marginY = 16.scale
    }
    
    let width = Constants.width
    
    private var tagViews: [TagView] = []
    private var height = CGFloat(0)
    
    override func layoutSubviews() {
        defer { rearrangeViews() }
        
        super.layoutSubviews()
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: width, height: height)
    }
}

// MARK: Public
extension TagsView {
    func addTags(_ array: [String]) {
        let views = array.map { createNewTagView($0) }
        
        views.forEach {
            tagViews.append($0)
        }
        
        rearrangeViews()
    }
    
    func removeTag(_ text: String) {
        tagViews
            .reversed()
            .filter { $0.text == text }
            .forEach { removeTagView($0) }
    }
    
    func removeAllTags() {
        defer {
            tagViews = []
            rearrangeViews()
        }
        
        tagViews.forEach { $0.removeFromSuperview() }
    }
}

// MARK: Private
private extension TagsView {
    func createNewTagView(_ text: String) -> TagView {
        let view = TagView(text: text)
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.layer.borderColor = Appearance.white.withAlphaComponent(0.1).cgColor
        view.layer.borderWidth = 1.scale
        view.backgroundColor = Appearance.white.withAlphaComponent(0.15)
        view.frame.size = view.intrinsicContentSize
        return view
    }
    
    func rearrangeViews() {
        tagViews.forEach {
            $0.removeFromSuperview()
        }
        
        var x = CGFloat(0)
        var y = CGFloat(0)
        var lastHeight = CGFloat(0)
        
        tagViews.forEach { tagView in
            if (x + tagView.frame.width) > width {
                x = 0
                y += lastHeight + Constants.marginY
                lastHeight = 0
            }
            
            tagView.frame.size = tagView.intrinsicContentSize
            tagView.frame.origin = CGPoint(x: x, y: y)
            
            x += tagView.frame.width + Constants.marginX
            lastHeight = max(lastHeight, tagView.frame.height)
            
            addSubview(tagView)
        }
        
        height = y + lastHeight
        
        invalidateIntrinsicContentSize()
    }
    
    func removeTagView(_ tagView: TagView) {
        defer {
            rearrangeViews()
        }
        
        tagView.removeFromSuperview()
        
        if let index = tagViews.firstIndex(of: tagView) {
            tagViews.remove(at: index)
        }
    }
}

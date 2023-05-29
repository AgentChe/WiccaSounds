//
//  TagsView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit

final class TagsView: UIView {
    let width = 343.scale
    
    private var tagViews: [TagView] = []
    private var rowViews: [UIView] = []
    private var tagViewHeight: CGFloat = 0
    private var rows = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func layoutSubviews() {
        defer { rearrangeViews() }
        super.layoutSubviews()
    }
    
    override var intrinsicContentSize: CGSize {
        var height = CGFloat(rows) * (tagViewHeight + 16.scale)
        if rows > 0 {
            height -= 16.scale
        }
        return CGSize(width: width, height: height)
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
        view.titleEdgeInsets = UIEdgeInsets(top: 6.scale, left: 12.scale, bottom: 8.scale, right: 12.scale)
        view.backgroundColor = Appearance.white.withAlphaComponent(0.15)
        view.frame.size = view.intrinsicContentSize
        return view
    }
    
    func rearrangeViews() {
        let views = tagViews as [UIView] + rowViews
        views.forEach {
            $0.removeFromSuperview()
        }
        rowViews.removeAll(keepingCapacity: true)
        
        var currentRow = 0
        var currentRowView: UIView!
        var currentRowTagCount = 0
        var currentRowWidth: CGFloat = 0
        
        for tagView in tagViews {
            tagView.frame.size = tagView.intrinsicContentSize
            tagViewHeight = tagView.frame.height
            
            if currentRowTagCount == 0 || currentRowWidth + tagView.frame.width > width {
                currentRow += 1
                currentRowWidth = 0
                currentRowTagCount = 0
                currentRowView = UIView()
                currentRowView.frame.origin.y = CGFloat(currentRow - 1) * (tagViewHeight + 16.scale)
                
                rowViews.append(currentRowView)
                addSubview(currentRowView)

                tagView.frame.size.width = min(tagView.frame.size.width, width)
            }
            
            tagView.frame.origin = CGPoint(x: currentRowWidth, y: 0)
            currentRowView.addSubview(tagView)
            
            currentRowTagCount += 1
            currentRowWidth += tagView.frame.width + 8.scale
            currentRowView.frame.origin.x = 0
            currentRowView.frame.size.width = currentRowWidth
            currentRowView.frame.size.height = max(tagViewHeight, currentRowView.frame.height)
        }
        rows = currentRow
        
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

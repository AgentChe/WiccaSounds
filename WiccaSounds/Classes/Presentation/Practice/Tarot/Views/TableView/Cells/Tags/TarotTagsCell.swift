//
//  TarotTagsCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit

final class TarotTagsCell: UITableViewCell {
    lazy var tagsView = makeTagsView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TarotTagsCell {
    func setup(element: [String]) {
        tagsView.removeAllTags()
        tagsView.addTags(element)
    }
}

// MARK: Private
private extension TarotTagsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension TarotTagsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tagsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            tagsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            tagsView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            tagsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TarotTagsCell {
    func makeTagsView() -> TagsView {
        let view = TagsView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

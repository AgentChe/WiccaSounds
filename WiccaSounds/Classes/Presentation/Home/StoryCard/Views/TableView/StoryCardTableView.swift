//
//  StoryCardTableView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 25.10.2022.
//

import UIKit

final class StoryCardTableView: UITableView {
    private lazy var elements = [StoryCardTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension StoryCardTableView {
    func setup(elements: [StoryCardTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension StoryCardTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .name(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: StoryCardNameCell.self)) as! StoryCardNameCell
            cell.setup(element: element)
            return cell
        case .image(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: StoryCardImageCell.self)) as! StoryCardImageCell
            cell.setup(element: element)
            return cell
        case .text(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: StoryCardTextCell.self)) as! StoryCardTextCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension StoryCardTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension StoryCardTableView {
    func initialize() {
        register(StoryCardNameCell.self, forCellReuseIdentifier: String(describing: StoryCardNameCell.self))
        register(StoryCardImageCell.self, forCellReuseIdentifier: String(describing: StoryCardImageCell.self))
        register(StoryCardTextCell.self, forCellReuseIdentifier: String(describing: StoryCardTextCell.self))
        
        dataSource = self
        delegate = self
    }
}

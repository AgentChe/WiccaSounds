//
//  ContentTableView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 23.03.2023.
//

import UIKit

final class ContentTableView: UITableView {
    lazy var elements = [ContentTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ContentTableView {
    func setup(elements: [ContentTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ContentTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ContentTitleCell.self)) as! ContentTitleCell
            cell.setup(element: element)
            return cell
        case .text(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ContentTextCell.self)) as! ContentTextCell
            cell.setup(element: element)
            return cell
        case .image(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ContentImageCell.self)) as! ContentImageCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ContentTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension ContentTableView {
    func initialize() {
        register(ContentTitleCell.self, forCellReuseIdentifier: String(describing: ContentTitleCell.self))
        register(ContentTextCell.self, forCellReuseIdentifier: String(describing: ContentTextCell.self))
        register(ContentImageCell.self, forCellReuseIdentifier: String(describing: ContentImageCell.self))
        
        dataSource = self
        delegate = self
    }
}

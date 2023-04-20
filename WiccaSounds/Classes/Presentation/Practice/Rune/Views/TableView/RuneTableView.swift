//
//  RuneTableView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit

final class RuneTableView: UITableView {
    lazy var elements = [RuneTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RuneTableView {
    func setup(elements: [RuneTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension RuneTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .name(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TarotNameCell.self)) as! TarotNameCell
            cell.setup(element: element)
            return cell
        case .image(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: RuneImageCell.self)) as! RuneImageCell
            cell.setup(element: element)
            return cell
        case .title(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TarotTitleCell.self)) as! TarotTitleCell
            cell.setup(element: element)
            return cell
        case .text(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TarotTextCell.self)) as! TarotTextCell
            cell.setup(element: element)
            return cell
        case .contentImage(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TarotContentImageCell.self)) as! TarotContentImageCell
            cell.setup(element: element)
            return cell
        case .tags(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TarotTagsCell.self)) as! TarotTagsCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension RuneTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension RuneTableView {
    func initialize() {
        register(TarotNameCell.self, forCellReuseIdentifier: String(describing: TarotNameCell.self))
        register(RuneImageCell.self, forCellReuseIdentifier: String(describing: RuneImageCell.self))
        register(TarotTitleCell.self, forCellReuseIdentifier: String(describing: TarotTitleCell.self))
        register(TarotTextCell.self, forCellReuseIdentifier: String(describing: TarotTextCell.self))
        register(TarotContentImageCell.self, forCellReuseIdentifier: String(describing: TarotContentImageCell.self))
        register(TarotTagsCell.self, forCellReuseIdentifier: String(describing: TarotTagsCell.self))
        
        dataSource = self
        delegate = self
    }
}

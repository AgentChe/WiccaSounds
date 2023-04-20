//
//  TarotTableView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import UIKit

protocol TarotTableDelegate: AnyObject {
    func tarotDidSelect(mode: TarotModeCell.Mode)
}

final class TarotTableView: UITableView {
    weak var mainDelegate: TarotTableDelegate?
    
    lazy var elements = [TarotTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension TarotTableView {
    func setup(elements: [TarotTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension TarotTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .name(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TarotNameCell.self)) as! TarotNameCell
            cell.setup(element: element)
            return cell
        case .mode(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TarotModeCell.self)) as! TarotModeCell
            cell.didSelect = { [weak self] mode in
                self?.mainDelegate?.tarotDidSelect(mode: mode)
            }
            cell.setup(mode: element)
            return cell
        case .image(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: TarotImageCell.self)) as! TarotImageCell
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
extension TarotTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension TarotTableView {
    func initialize() {
        register(TarotNameCell.self, forCellReuseIdentifier: String(describing: TarotNameCell.self))
        register(TarotModeCell.self, forCellReuseIdentifier: String(describing: TarotModeCell.self))
        register(TarotImageCell.self, forCellReuseIdentifier: String(describing: TarotImageCell.self))
        register(TarotTitleCell.self, forCellReuseIdentifier: String(describing: TarotTitleCell.self))
        register(TarotTextCell.self, forCellReuseIdentifier: String(describing: TarotTextCell.self))
        register(TarotContentImageCell.self, forCellReuseIdentifier: String(describing: TarotContentImageCell.self))
        register(TarotTagsCell.self, forCellReuseIdentifier: String(describing: TarotTagsCell.self))
        
        dataSource = self
        delegate = self
    }
}

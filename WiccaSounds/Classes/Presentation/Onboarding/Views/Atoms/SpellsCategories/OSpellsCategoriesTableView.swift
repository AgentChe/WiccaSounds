//
//  OSpellsCategoriesTableView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.03.2023.
//

import UIKit

protocol OSpellsCategoriesTableDelegate: AnyObject {
    func onbSpellsCategoriesTableDidMarked(element: OSpellsCategoriesTableElement)
}

final class OSpellsCategoriesTableView: UITableView {
    weak var mainDelegate: OSpellsCategoriesTableDelegate?
    
    lazy var elements = [OSpellsCategoriesTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OSpellsCategoriesTableView {
    func setup(elements: [OSpellsCategoriesTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension OSpellsCategoriesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: OSpellsCategoriesTableCell.self)) as! OSpellsCategoriesTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension OSpellsCategoriesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        element.marked.toggle()
        
        reloadData()
        
        mainDelegate?.onbSpellsCategoriesTableDidMarked(element: element)
    }
}

// MARK: Private
private extension OSpellsCategoriesTableView {
    func initialize() {
        register(OSpellsCategoriesTableCell.self, forCellReuseIdentifier: String(describing: OSpellsCategoriesTableCell.self))
        
        dataSource = self
        delegate = self
    }
}

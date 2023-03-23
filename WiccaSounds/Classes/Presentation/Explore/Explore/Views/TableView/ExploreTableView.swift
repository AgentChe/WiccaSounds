//
//  ExploreTableView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 22.03.2023.
//

import UIKit

protocol ExploreTableDelegate: AnyObject {
    func exploreDidTap(spell: Spell)
    func exploreDidTap(unit: ExploreUnitElement.Unit)
}

final class ExploreTableView: UITableView {
    weak var mainDelegate: ExploreTableDelegate?
    
    lazy var sections = [ExploreTableSection]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ExploreTableView {
    func setup(sections: [ExploreTableSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension ExploreTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].elements[indexPath.row] {
        case .spellsCategory(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExploreSpellCategoryCell.self)) as! ExploreSpellCategoryCell
            cell.setup(element: element)
            return cell
        case .spell(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExploreSpellCell.self)) as! ExploreSpellCell
            cell.setup(element: element)
            return cell
        case .unit(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ExploreRowUnitsCell.self)) as! ExploreRowUnitsCell
            cell.setup(element: element)
            cell.didTap = { [weak self] unit in
                self?.mainDelegate?.exploreDidTap(unit: unit)
            }
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ExploreTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.section].elements[indexPath.row] {
        case .spell(let element):
            mainDelegate?.exploreDidTap(spell: element.spell)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].elements[indexPath.row] {
        case .unit:
            return 233.scale
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension ExploreTableView {
    func initialize() {
        register(ExploreSpellCategoryCell.self, forCellReuseIdentifier: String(describing: ExploreSpellCategoryCell.self))
        register(ExploreSpellCell.self, forCellReuseIdentifier: String(describing: ExploreSpellCell.self))
        register(ExploreRowUnitsCell.self, forCellReuseIdentifier: String(describing: ExploreRowUnitsCell.self))
        
        dataSource = self
        delegate = self
    }
}

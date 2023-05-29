//
//  ExploreTableView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 22.03.2023.
//

import UIKit

protocol ExploreTableDelegate: AnyObject {
    func exploreDidTap(spell: ExploreSpellElement)
    func exploreDidTap(unit: ExploreUnitElement.Unit)
}

final class ExploreTableView: UITableView {
    weak var mainDelegate: ExploreTableDelegate?
    
    lazy var sections = [ExploreTableSection]()
    
    private lazy var headerFooterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
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
        case .empty:
            let cell = dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
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
            mainDelegate?.exploreDidTap(spell: element)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].elements[indexPath.row] {
        case .empty:
            return 16.scale
        case .unit:
            return 233.scale
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerFooterView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard sections[indexPath.section].corner else {
            return
        }
        
        let cornerRadius: CGFloat = cell.layer.cornerRadius
        let layer = CAShapeLayer()
        let pathRef = CGMutablePath()
        let bounds = cell.bounds
        
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if indexPath.row == 0 {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY),
                           tangent2End: CGPoint(x: bounds.midX, y: bounds.minY),
                           radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY),
                           tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
                           radius: cornerRadius)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY),
                           radius: cornerRadius)
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
                           radius: cornerRadius)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        } else {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY),
                           radius: cornerRadius)
            pathRef.move(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
                           radius: cornerRadius)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        }
            
        layer.path = pathRef
        layer.strokeColor = Appearance.white.withAlphaComponent(0.15).cgColor
        layer.lineWidth = 1.scale
        layer.fillColor = UIColor.clear.cgColor
            
        let backgroundView = UIView(frame: bounds)
        backgroundView.layer.insertSublayer(layer, at: 0)
        backgroundView.backgroundColor = Appearance.white.withAlphaComponent(0.1)
        cell.backgroundView = backgroundView
    }
}

// MARK: Private
private extension ExploreTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(ExploreSpellCategoryCell.self, forCellReuseIdentifier: String(describing: ExploreSpellCategoryCell.self))
        register(ExploreSpellCell.self, forCellReuseIdentifier: String(describing: ExploreSpellCell.self))
        register(ExploreRowUnitsCell.self, forCellReuseIdentifier: String(describing: ExploreRowUnitsCell.self))
        
        dataSource = self
        delegate = self
    }
}

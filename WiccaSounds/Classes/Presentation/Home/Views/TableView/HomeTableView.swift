//
//  HomeTableView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.03.2023.
//

import UIKit

protocol HomeTableDelegate: AnyObject {
    func homeTableDidTap(spell: Spell)
    func homeTableDidTap(story: StoryCover)
    func homeTableDidTap(tipElement: HomeTipElement)
}

final class HomeTableView: UITableView {
    weak var mainDelegate: HomeTableDelegate?
    
    lazy var sections = [HomeTableSection]()
    
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
extension HomeTableView {
    func setup(sections: [HomeTableSection]) {
        self.sections = sections
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension HomeTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section].elements[indexPath.row] {
        case .todayTitle:
            return dequeueReusableCell(withIdentifier: String(describing: HomeTodayCell.self), for: indexPath)
        case .spell(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeSpellCell.self), for: indexPath) as! HomeSpellCell
            cell.setup(element: element)
            cell.didTapMoreDetails = { [weak self] spell in
                self?.mainDelegate?.homeTableDidTap(spell: spell)
            }
            return cell
        case .stories(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeStoriesCell.self)) as! HomeStoriesCell
            cell.collectionView.setup(elements: element) { [weak self] story in
                self?.mainDelegate?.homeTableDidTap(story: story)
            }
            return cell
        case .lunar(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeLunarCell.self)) as! HomeLunarCell
            cell.setup(element: element)
            return cell
        case .tips(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeTipsCell.self)) as! HomeTipsCell
            cell.collectionView.setup(elements: element) { [weak self] tip in
                self?.mainDelegate?.homeTableDidTap(tipElement: tip)
            }
            return cell
        case .tipContent(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: HomeTipContentCell.self)) as! HomeTipContentCell
            cell.setup(tip: element)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension HomeTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].elements[indexPath.row] {
        case .spell:
            return 224.scale
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
private extension HomeTableView {
    func initialize() {
        register(HomeTodayCell.self, forCellReuseIdentifier: String(describing: HomeTodayCell.self))
        register(HomeSpellCell.self, forCellReuseIdentifier: String(describing: HomeSpellCell.self))
        register(HomeStoriesCell.self, forCellReuseIdentifier: String(describing: HomeStoriesCell.self))
        register(HomeLunarCell.self, forCellReuseIdentifier: String(describing: HomeLunarCell.self))
        register(HomeTipsCell.self, forCellReuseIdentifier: String(describing: HomeTipsCell.self))
        register(HomeTipContentCell.self, forCellReuseIdentifier: String(describing: HomeTipContentCell.self))
        
        dataSource = self
        delegate = self
    }
}

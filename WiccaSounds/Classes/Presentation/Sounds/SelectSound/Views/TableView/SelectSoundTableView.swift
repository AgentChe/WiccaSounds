//
//  SelectSoundTableView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 27.04.2023.
//

import UIKit

protocol SelectSoundTableDelegate: AnyObject {
    func selectSoundTable(element: SoundCellElement)
}

final class SelectSoundTableView: UITableView {
    weak var mainDelegate: SelectSoundTableDelegate?
    
    private lazy var elements = [NoiseCategory]()
    private lazy var isActiveSubscription = false
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SelectSoundTableView {
    func setup(noiseCategories: [NoiseCategory], isActiveSubscription: Bool) {
        self.elements = noiseCategories
        self.isActiveSubscription = isActiveSubscription
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension SelectSoundTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: SoundGroupCell.self)) as! SoundGroupCell
        cell.setup(model: elements[indexPath.row], isActiveSubscription: isActiveSubscription) { [weak self] element in
            self?.mainDelegate?.selectSoundTable(element: element)
        }
        return cell
    }
}

// MARK: UITableViewDelegate
extension SelectSoundTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: Private
private extension SelectSoundTableView {
    func initialize() {
        register(SoundGroupCell.self, forCellReuseIdentifier: String(describing: SoundGroupCell.self))
        
        dataSource = self
        delegate = self
    }
}

//
//  ExploreRowUnitsCell.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 23.03.2023.
//

import UIKit

final class ExploreRowUnitsCell: UITableViewCell {
    var didTap: ((ExploreUnitElement.Unit) -> Void)?
    
    lazy var leftButton = makeUnitButton()
    lazy var rightButton = makeUnitButton()
    
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
extension ExploreRowUnitsCell {
    func setup(element: ExploreUnitElement) {
        leftButton.setup(element: element.unit1)
        rightButton.setup(element: element.unit2)
    }
}

// MARK: Private
private extension ExploreRowUnitsCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func didTap(sender: UITapGestureRecognizer) {
        guard
            let button = sender.view as? ExploreUnitButton,
            let unit = button.element
        else {
            return
        }
        
        didTap?(unit)
    }
}

// MARK: Make constraints
private extension ExploreRowUnitsCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            leftButton.widthAnchor.constraint(equalToConstant: 163.scale),
            leftButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            leftButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale),
            leftButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightButton.widthAnchor.constraint(equalToConstant: 163.scale),
            rightButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            rightButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale),
            rightButton.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ExploreRowUnitsCell {
    func makeUnitButton() -> ExploreUnitButton {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        let view = ExploreUnitButton()
        view.backgroundColor = UIColor.clear
        view.addGestureRecognizer(gesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

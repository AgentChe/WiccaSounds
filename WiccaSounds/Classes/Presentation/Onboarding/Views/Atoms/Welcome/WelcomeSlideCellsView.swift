//
//  WelcomeSlideCellsView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.03.2023.
//

import UIKit

final class WelcomeSlideCellsView: UIView, WelcomeSlideAtomView {
    let slide: OWelcomeView.Slide
    
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(title: "Onboarding.Welcome.Slide3.Cell1".localized)
    lazy var cell2 = makeCell(title: "Onboarding.Welcome.Slide3.Cell2".localized)
    lazy var cell3 = makeCell(title: "Onboarding.Welcome.Slide3.Cell3".localized)
    lazy var cell4 = makeCell(title: "Onboarding.Welcome.Slide3.Cell4".localized)
    
    init(slide: OWelcomeView.Slide) {
        self.slide = slide
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension WelcomeSlideCellsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 201.scale),
            imageView.heightAnchor.constraint(equalToConstant: 120.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale),
            cell1.heightAnchor.constraint(equalToConstant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 17.scale),
            cell2.heightAnchor.constraint(equalToConstant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 17.scale),
            cell3.heightAnchor.constraint(equalToConstant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell4.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell4.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell4.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: 17.scale),
            cell4.heightAnchor.constraint(equalToConstant: 26.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WelcomeSlideCellsView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Welcome.Slide3")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.bold(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Welcome.Slide3.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(title: String) -> WelcomeCellView {
        let view = WelcomeCellView(title: title)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

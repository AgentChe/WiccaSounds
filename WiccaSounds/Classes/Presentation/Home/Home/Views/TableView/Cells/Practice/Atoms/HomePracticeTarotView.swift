//
//  HomePracticeTarotView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 29.03.2023.
//

import UIKit
import Kingfisher

final class HomePracticeTarotView: UIView {
    var didOpenTarot: ((TarotOnDay) -> Void)?
    var didShowTarot: ((TarotCover) -> Void)?
    
    lazy var label = makeLabel()
    lazy var button = makeButton()
    lazy var tarotContainer = makeTarotContainer()
    lazy var coverTarotView = makeCoverTarotView()
    lazy var imageTarotView = makeImageTarotView()
    
    private lazy var tarotWidthConstraint = NSLayoutConstraint()
    private lazy var tarotHeightConstraint = NSLayoutConstraint()
    private lazy var tarotTopConstraint = NSLayoutConstraint()
    
    private lazy var isOpened = false
    private var tarotOnToday: TarotOnDay!
    
    private lazy var descriptionAttrs = TextAttributes()
        .textColor(Appearance.white.withAlphaComponent(0.7))
        .font(Fonts.Inter.regular(size: 14.scale))
        .lineHeight(21.scale)
        .textAlignment(.center)
        .lineBreakMode(.byTruncatingTail)
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.bold(size: 18.scale))
        .lineHeight(21.6.scale)
        .textAlignment(.center)
        .lineBreakMode(.byTruncatingTail)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initiaize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension HomePracticeTarotView {
    func setup(tarotOnToday: TarotOnDay) {
        guard self.tarotOnToday == nil else {
            return
        }
        
        self.tarotOnToday = tarotOnToday
        
        isOpened = tarotOnToday.isOpened
        
        updateUI()
        updateVisibleTarot()
        updateVisibleButton()
        resizeTarot(animate: false)
    }
}

// MARK: Private
private extension HomePracticeTarotView {
    func initiaize() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openTarot))
        coverTarotView.isUserInteractionEnabled = true
        coverTarotView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func openTarot() {
        flipToImage()
        
        didOpenTarot?(tarotOnToday)
    }
    
    func flipToImage() {
        guard !isOpened else {
            return
        }
        
        isOpened = true
        updateVisibleTarot()
        
        UIView.transition(from: coverTarotView, to: imageTarotView, duration: 0.5, options: [.transitionFlipFromRight]) { [weak self] result in
            self?.updateUI()
            self?.updateVisibleButton()
            self?.resizeTarot(animate: true)
        }
    }
    
    @objc
    func didTapButton() {
        didShowTarot?(tarotOnToday.tarot)
    }
    
    func updateUI() {
        imageTarotView.kf.setImage(with: tarotOnToday.tarot.image)
        
        let title = isOpened ? tarotOnToday.tarot.name : "Home.Practice.Tarot.Title".localized
        let attrs = isOpened ? nameAttrs : descriptionAttrs
        label.attributedText = title.attributed(with: attrs)
    }
    
    func updateVisibleTarot() {
        coverTarotView.isHidden = isOpened
        imageTarotView.isHidden = !isOpened
    }
    
    func updateVisibleButton() {
        button.isHidden = !isOpened
    }
    
    func resizeTarot(animate: Bool) {
        let width = isOpened ? 166.scale : 192.scale
        let height = isOpened ? 325.scale : 376.scale
        let top = isOpened ? 48.scale : 68.scale
        
        NSLayoutConstraint.deactivate([
            tarotWidthConstraint,
            tarotHeightConstraint,
            tarotTopConstraint
        ])
        
        tarotWidthConstraint.constant = width
        tarotHeightConstraint.constant = height
        tarotTopConstraint.constant = top
        
        NSLayoutConstraint.activate([
            tarotWidthConstraint,
            tarotHeightConstraint,
            tarotTopConstraint
        ])
        
        if animate {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.layoutIfNeeded()
            })
        } else {
            layoutIfNeeded()
        }
    }
}

// MARK: Make constraints
private extension HomePracticeTarotView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 33.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -33.scale),
            label.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 226.scale),
            button.heightAnchor.constraint(equalToConstant: 47.scale),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        tarotWidthConstraint = tarotContainer.widthAnchor.constraint(equalToConstant: 192.scale)
        tarotHeightConstraint = tarotContainer.heightAnchor.constraint(equalToConstant: 376.scale)
        tarotTopConstraint = tarotContainer.topAnchor.constraint(equalTo: topAnchor, constant: 68.scale)
        NSLayoutConstraint.activate([
            tarotWidthConstraint,
            tarotHeightConstraint,
            tarotTopConstraint,
            tarotContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            coverTarotView.leadingAnchor.constraint(equalTo: tarotContainer.leadingAnchor),
            coverTarotView.trailingAnchor.constraint(equalTo: tarotContainer.trailingAnchor),
            coverTarotView.topAnchor.constraint(equalTo: tarotContainer.topAnchor),
            coverTarotView.bottomAnchor.constraint(equalTo: tarotContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageTarotView.leadingAnchor.constraint(equalTo: tarotContainer.leadingAnchor),
            imageTarotView.trailingAnchor.constraint(equalTo: tarotContainer.trailingAnchor),
            imageTarotView.topAnchor.constraint(equalTo: tarotContainer.topAnchor),
            imageTarotView.bottomAnchor.constraint(equalTo: tarotContainer.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension HomePracticeTarotView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 16.scale))
        
        let view = UIButton()
        view.backgroundColor = Appearance.primary
        view.layer.cornerRadius = 23.scale
        view.setAttributedTitle("Home.Practice.Tarot.Button".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTarotContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCoverTarotView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Home.Tarot.Cover")
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        tarotContainer.addSubview(view)
        return view
    }
    
    func makeImageTarotView() -> UIImageView {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        tarotContainer.addSubview(view)
        return view
    }
}

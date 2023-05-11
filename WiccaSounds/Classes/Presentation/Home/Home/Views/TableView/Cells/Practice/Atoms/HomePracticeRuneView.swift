//
//  HomePracticeRuneView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 10.04.2023.
//

import UIKit
import Kingfisher

final class HomePracticeRuneView: UIView {
    var didOpenRune: ((RuneOnDay) -> Void)?
    var didShowRune: ((RuneCover) -> Void)?
    
    lazy var label = makeLabel()
    lazy var button = makeButton()
    lazy var runeView = makeImageView()
    
    private lazy var runeTopConstraint = NSLayoutConstraint()
    
    private lazy var isOpened = false
    private var runeOnToday: RuneOnDay!
    private var runeImage: UIImage?
    private var animateCompleted = false
    
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
extension HomePracticeRuneView {
    func setup(runeOnToday: RuneOnDay) {
        guard self.runeOnToday == nil else {
            return
        }
        
        self.runeOnToday = runeOnToday
        
        isOpened = runeOnToday.isOpened
        
        setupUI()
        updateVisibleButton()
        moveRune(animate: false)
        loadRuneImageIfNeeded()
    }
}

// MARK: Private
private extension HomePracticeRuneView {
    func initiaize() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openRune))
        runeView.isUserInteractionEnabled = true
        runeView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func openRune() {
        guard !isOpened else {
            return
        }
        
        isOpened = true
        
        animateRunes { [weak self] in
            guard let self = self else {
                return
            }
            
            self.animateCompleted = true
            self.setupRuneImage()
            self.updateUI()
            self.updateVisibleButton()
            self.moveRune(animate: true)
            self.didOpenRune?(self.runeOnToday)
        }
    }
    
    @objc
    func didTapButton() {
        didShowRune?(runeOnToday.rune)
    }
    
    func animateRunes(completion: @escaping (() -> Void)) {
        runeView.isHidden = true
        runeView.image = UIImage(named: "Home.Rune.7")
        runeView.isHidden = false
        
        let runeImages = [
            UIImage(named: "Home.Rune.Empty"),
            UIImage(named: "Home.Rune.1"),
            UIImage(named: "Home.Rune.2"),
            UIImage(named: "Home.Rune.3"),
            UIImage(named: "Home.Rune.4"),
            UIImage(named: "Home.Rune.5"),
            UIImage(named: "Home.Rune.6"),
            UIImage(named: "Home.Rune.7")
        ].compactMap { $0 }
        
        runeView.animationImages = runeImages
        runeView.animationDuration = 2
        runeView.animationRepeatCount = 1
        runeView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: completion)
    }
    
    func setupUI() {
        if isOpened {
            runeView.kf.setImage(with: runeOnToday.rune.image)
        } else {
            runeView.image = UIImage(named: "Home.Rune.Cover")
        }
        
        let title = isOpened ? runeOnToday.rune.name : "Home.Practice.Rune.Title".localized
        let attrs = isOpened ? nameAttrs : descriptionAttrs
        label.attributedText = title.attributed(with: attrs)
    }
    
    func updateUI() {
        let title = isOpened ? runeOnToday.rune.name : "Home.Practice.Rune.Title".localized
        let attrs = isOpened ? nameAttrs : descriptionAttrs
        label.attributedText = title.attributed(with: attrs)
    }
    
    func updateVisibleButton() {
        button.isHidden = !isOpened
    }
    
    func moveRune(animate: Bool) {
        runeTopConstraint.isActive = false
        
        runeTopConstraint.constant = isOpened ? 72.scale : 109.scale
        
        runeTopConstraint.isActive = true
        
        if animate {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.layoutIfNeeded()
            })
        } else {
            layoutIfNeeded()
        }
    }
    
    func loadRuneImageIfNeeded() {
        guard !isOpened else {
            return
        }
        
        ImageDownloader.default.downloadImage(with: runeOnToday.rune.image) { [weak self] result in
            guard case let .success(data) = result else {
                return
            }
            
            self?.runeImage = data.image
            
            self?.setupRuneImage()
        }
    }
    
    func setupRuneImage() {
        guard animateCompleted, let image = runeImage else {
            return
        }
        
        runeView.image = image
    }
}

// MARK: Make constraints
private extension HomePracticeRuneView {
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
        
        runeTopConstraint = runeView.topAnchor.constraint(equalTo: topAnchor, constant: 109.scale)
        NSLayoutConstraint.activate([
            runeView.widthAnchor.constraint(equalToConstant: 199.scale),
            runeView.heightAnchor.constraint(equalToConstant: 293.scale),
            runeTopConstraint,
            runeView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}

// MARK: Lazy initialization
private extension HomePracticeRuneView {
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
        view.setAttributedTitle("Home.Practice.Rune.Button".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.backgroundColor = UIColor.clear
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

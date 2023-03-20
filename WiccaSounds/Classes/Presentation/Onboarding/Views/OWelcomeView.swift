//
//  OWelcomeView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 19.10.2022.
//

import UIKit

final class OWelcomeView: OSlideView {
    enum Slide {
        case text1, text2, cells
    }
    
    lazy var titleLabel = makeTitleLabel()
    lazy var slide1View = makeSlide1View()
    lazy var slide2View = makeSlide2View()
    lazy var slide3View = makeSlide3View()
    lazy var indicator1View = makeIndicatorView()
    lazy var indicator2View = makeIndicatorView()
    lazy var indicator3View = makeIndicatorView()
    lazy var continueButton = makeContinueButton()
    
    private lazy var slide1LeadingConstraint = NSLayoutConstraint()
    private lazy var slide2LeadingConstraint = NSLayoutConstraint()
    private lazy var slide3LeadingConstraint = NSLayoutConstraint()
    
    private lazy var currentSlide = Slide.text1
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        updateIndicators()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OWelcomeView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    @objc
    func didLeftSwipe(sender: UISwipeGestureRecognizer) {
        updateSlides(direction: true)
    }
    
    @objc
    func didRightSwipe(sender: UISwipeGestureRecognizer) {
        updateSlides(direction: false)
    }
    
    func updateSlides(direction left: Bool) {
        guard let updatedSlide = slideChanged(direction: left) else {
            return
        }
        
        currentSlide = updatedSlide
        
        updateIndicators()
        updatePositions()
    }
    
    func updateIndicators() {
        let selected = Appearance.white
        let unselected = Appearance.white.withAlphaComponent(0.4)
        
        indicator1View.backgroundColor = (currentSlide == .text1) ? selected : unselected
        indicator2View.backgroundColor = (currentSlide == .text2) ? selected : unselected
        indicator3View.backgroundColor = (currentSlide == .cells) ? selected : unselected
    }
    
    func updatePositions() {
        NSLayoutConstraint.deactivate([
            slide1LeadingConstraint,
            slide2LeadingConstraint,
            slide3LeadingConstraint
        ])
        
        let leadings = leading()
        slide1LeadingConstraint.constant = leadings.0
        slide2LeadingConstraint.constant = leadings.1
        slide3LeadingConstraint.constant = leadings.2
        
        NSLayoutConstraint.activate([
            slide1LeadingConstraint,
            slide2LeadingConstraint,
            slide3LeadingConstraint
        ])
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.layoutIfNeeded()
        })
    }
    
    func slideChanged(direction left: Bool) -> Slide? {
        switch currentSlide {
        case .text1:
            return left ? .text2 : nil
        case .text2:
            return left ? .cells : .text1
        case .cells:
            return left ? nil : .text2
        }
    }
    
    func leading() -> (CGFloat, CGFloat, CGFloat) {
        switch currentSlide {
        case .text1:
            return (32.scale, 359.scale, 686.scale)
        case .text2:
            return (-295.scale, 32.scale, 359.scale)
        case .cells:
            return (-686.scale, -295.scale, 32.scale)
        }
    }
}

// MARK: Make constraints
private extension OWelcomeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 90.scale : 40.scale),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        slide1LeadingConstraint = slide1View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale)
        NSLayoutConstraint.activate([
            slide1View.widthAnchor.constraint(equalToConstant: 311.scale),
            slide1View.heightAnchor.constraint(equalToConstant: 398.scale),
            slide1View.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 24.scale : 16.scale),
            slide1LeadingConstraint
        ])
        
        slide2LeadingConstraint = slide2View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 359.scale)
        NSLayoutConstraint.activate([
            slide2View.widthAnchor.constraint(equalToConstant: 311.scale),
            slide2View.heightAnchor.constraint(equalToConstant: 398.scale),
            slide2View.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 24.scale : 16.scale),
            slide2LeadingConstraint
        ])
        
        slide3LeadingConstraint = slide3View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 686.scale)
        NSLayoutConstraint.activate([
            slide3View.widthAnchor.constraint(equalToConstant: 311.scale),
            slide3View.heightAnchor.constraint(equalToConstant: 398.scale),
            slide3View.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 24.scale : 16.scale),
            slide3LeadingConstraint
        ])
        
        NSLayoutConstraint.activate([
            indicator1View.widthAnchor.constraint(equalToConstant: 8.scale),
            indicator1View.heightAnchor.constraint(equalToConstant: 8.scale),
            indicator1View.trailingAnchor.constraint(equalTo: indicator2View.leadingAnchor, constant: -8.scale),
            indicator1View.centerYAnchor.constraint(equalTo: indicator2View.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            indicator2View.widthAnchor.constraint(equalToConstant: 8.scale),
            indicator2View.heightAnchor.constraint(equalToConstant: 8.scale),
            indicator2View.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator2View.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: ScreenSize.isIphoneXFamily ? -29.scale : -21.scale)
        ])
        
        NSLayoutConstraint.activate([
            indicator3View.widthAnchor.constraint(equalToConstant: 8.scale),
            indicator3View.heightAnchor.constraint(equalToConstant: 8.scale),
            indicator3View.leadingAnchor.constraint(equalTo: indicator2View.trailingAnchor, constant: 8.scale),
            indicator3View.centerYAnchor.constraint(equalTo: indicator2View.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 56.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OWelcomeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.bold(size: 30.scale))
            .lineHeight(36.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Welcome.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSlide1View() -> WelcomeSlideTextView {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(didLeftSwipe(sender:)))
        swipeLeftGesture.direction = .left
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(didRightSwipe(sender:)))
        swipeRightGesture.direction = .right
        
        let view = WelcomeSlideTextView(
            slide: .text1,
            imageName: "Onboarding.Welcome.Slide1",
            title: "Onboarding.Welcome.Slide1.Title".localized,
            text: "Onboarding.Welcome.Slide1.Text".localized
        )
        view.backgroundColor = Appearance.white.withAlphaComponent(0.1.scale)
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.white.withAlphaComponent(0.15.scale).cgColor
        view.addGestureRecognizer(swipeLeftGesture)
        view.addGestureRecognizer(swipeRightGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSlide2View() -> WelcomeSlideTextView {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(didLeftSwipe(sender:)))
        swipeLeftGesture.direction = .left
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(didRightSwipe(sender:)))
        swipeRightGesture.direction = .right
        
        let view = WelcomeSlideTextView(
            slide: .text2,
            imageName: "Onboarding.Welcome.Slide2",
            title: "Onboarding.Welcome.Slide2.Title".localized,
            text: "Onboarding.Welcome.Slide2.Text".localized
        )
        view.backgroundColor = Appearance.white.withAlphaComponent(0.1.scale)
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.white.withAlphaComponent(0.15.scale).cgColor
        view.addGestureRecognizer(swipeLeftGesture)
        view.addGestureRecognizer(swipeRightGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSlide3View() -> WelcomeSlideCellsView {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(didLeftSwipe(sender:)))
        swipeLeftGesture.direction = .left
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(didRightSwipe(sender:)))
        swipeRightGesture.direction = .right
        let view = WelcomeSlideCellsView(slide: .cells)
        view.backgroundColor = Appearance.white.withAlphaComponent(0.1.scale)
        view.layer.cornerRadius = 10.scale
        view.layer.borderWidth = 1.scale
        view.layer.borderColor = Appearance.white.withAlphaComponent(0.15.scale).cgColor
        view.addGestureRecognizer(swipeLeftGesture)
        view.addGestureRecognizer(swipeRightGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIndicatorView() -> CircleView {
        let view = CircleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 17.scale))
            .letterSpacing(0.8.scale)
        
        let view = UIButton()
        view.backgroundColor = Appearance.primary
        view.layer.cornerRadius = 28.scale
        view.setAttributedTitle("Onboarding.Welcome.Button".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

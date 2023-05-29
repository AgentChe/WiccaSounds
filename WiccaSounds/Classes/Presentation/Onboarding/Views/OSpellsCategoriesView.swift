//
//  OSpellsCategoriesView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.03.2023.
//

import UIKit
import RxSwift

protocol OSpellsCategoriesDelegate: AnyObject {
    func onbSpellsCategoriesDidSelect(spellsCategories: [SpellsCategory])
}

final class OSpellsCategoriesView: OSlideView {
    weak var mainDelegate: OSpellsCategoriesDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var tableView = makeTableView()
    lazy var gradientView = makeGradientView()
    lazy var continueButton = makeContinueButton()
    
    private lazy var spellsManager = SpellsManager()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        continueEnableChanged()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        AmplitudeManager.shared.logEvent(name: "Onboarding Question Screen", parameters: ["step": 2])
    }
}

// MARK: OSpellsCategoriesTableDelegate
extension OSpellsCategoriesView: OSpellsCategoriesTableDelegate {
    func onbSpellsCategoriesTableDidMarked(element: OSpellsCategoriesTableElement) {
        continueEnableChanged()
    }
}

// MARK: Private
private extension OSpellsCategoriesView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        spellsManager
            .obtainCategories(forceUpdate: false)
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(tableView) { base, spellsCategories in
                let elements = spellsCategories.map { OSpellsCategoriesTableElement(spellsCategory: $0) }
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
    
    func continueEnableChanged() {
        let hasMarked = tableView.elements.contains(where: { $0.marked })
        
        continueButton.isEnabled = hasMarked
        continueButton.backgroundColor = hasMarked ? Appearance.primary : UIColor(integralRed: 54, green: 71, blue: 63)
        continueButton.titleLabel?.alpha = hasMarked ? 1 : 0.4
    }
    
    @objc
    func continueTapped() {
        let categories = tableView.elements
            .filter { $0.marked }
            .map { $0.spellsCategory }
        mainDelegate?.onbSpellsCategoriesDidSelect(spellsCategories: categories)
        
        onNext()
    }
}

// MARK: Make constraints
private extension OSpellsCategoriesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 90.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientView.topAnchor.constraint(equalTo: continueButton.topAnchor, constant: -12.scale)
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
private extension OSpellsCategoriesView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.bold(size: 20.scale))
            .lineHeight(24.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SpellsCategories.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> OSpellsCategoriesTableView {
        let view = OSpellsCategoriesTableView ()
        view.contentInset = UIEdgeInsets(top: 20.scale, left: 0, bottom: ScreenSize.isIphoneXFamily ? 128.scale : 98.scale, right: 0)
        view.setContentOffset(CGPoint(x: 0, y: -20.scale), animated: false)
        view.separatorStyle = .none
        view.layoutMargins = UIEdgeInsets.zero
        if #available(iOS 15.0, *) {
            view.sectionHeaderTopPadding = 0
        }
        view.mainDelegate = self
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGradientView() -> GradientView {
        let view = GradientView()
        view.gradientLayer.colors = [
            UIColor(integralRed: 13, green: 16, blue: 15, alpha: 0).cgColor,
            UIColor(integralRed: 14, green: 16, blue: 15, alpha: 1).cgColor
        ]
        view.gradientLayer.locations = [0, 0.4, 1]
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
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
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

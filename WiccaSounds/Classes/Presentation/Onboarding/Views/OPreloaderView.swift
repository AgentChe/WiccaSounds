//
//  OPreloaderView.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import UIKit
import RxSwift

final class OPreloaderView: OSlideView {
    weak var vc: UIViewController?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var imageView = makeImageView()
    lazy var loadingLabel = makeLabel()
    lazy var progressView = makeProgresView()
    lazy var progressLabel = makeLabel()
    
    private let combineData: OnboardingCombineData
    
    private var timer: Timer?
    
    private lazy var profileManager = ProfileManager()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private lazy var animationCompleted = false
    private lazy var requestCompleted = false
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var loadingLabelAttrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.semiBold(size: 16.scale))
        .lineHeight(22.4.scale)
        .letterSpacing(0.14.scale)
        .textAlignment(.center)
    private lazy var progressLabelAttrs = TextAttributes()
        .textColor(Appearance.white)
        .font(Fonts.Inter.semiBold(size: 20.scale))
        .lineHeight(24.scale)
        .textAlignment(.center)
    
    init(step: OnboardingView.Step, combineData: OnboardingCombineData) {
        self.combineData = combineData
        
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        calculatePercent()
        request()
    }
}

// MARK: Private
private extension OPreloaderView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func request() {
        guard let data = combineData.combineData() else {
            return
        }
        
        func source() -> Single<Void> {
            profileManager
                .set(spellsCategoriesIds: data.spellsCategoriesIds)
        }
        
        func error(err: Error) -> Observable<Void> {
            open(error: err)
        }
        
        observableRetrySingle
            .retry(source: { source() },
                   trigger: { error(err: $0) })
            .asDriver(onErrorDriveWith: .never())
            .drive(Binder(self) { base, void in
                base.requestCompleted = true
                base.checkCompleted()
            })
            .disposed(by: disposeBag)
    }
    
    func calculatePercent() {
        let duration = Double(7.5)
        var seconds = Double(0)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            seconds += 0.1
            
            var percent = Int(seconds / duration * 100)
            if percent > 100 {
                percent = 100
            }
            
            self.progressView.progress = Float(percent) / 100
            self.updateLoading(percent: percent)
            
            if seconds >= duration {
                timer.invalidate()
                
                self.calculatePercentFinish()
            }
        }
    }
    
    func updateLoading(percent: Int) {
        let string: String
        if percent <= 20 {
            string = "Onboarding.Preloader.Label1".localized
        } else if percent <= 40 {
            string = "Onboarding.Preloader.Label2".localized
        } else if percent <= 60 {
            string = "Onboarding.Preloader.Label3".localized
        } else if percent <= 80 {
            string = "Onboarding.Preloader.Label4".localized
        } else {
            string = "Onboarding.Preloader.Label5".localized
        }
        loadingLabel.attributedText = string.attributed(with: loadingLabelAttrs)
        
        progressLabel.attributedText = String(format: "%i%%", percent).attributed(with: progressLabelAttrs)
    }
    
    func calculatePercentFinish() {
        timer = nil
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            self?.animationCompleted = true
            self?.checkCompleted()
        }
    }
    
    func checkCompleted() {
        guard animationCompleted && requestCompleted else {
            return
        }
        
        onNext()
    }
    
    func open(error: Error) -> Observable<Void> {
        Observable<Void>
            .create { [weak self] observe in
                guard let self = self else {
                    return Disposables.create()
                }
                
                let vc = TryAgainViewController.make(error: error) {
                    observe.onNext(())
                }
                self.vc?.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}

// MARK: Make constraints
private extension OPreloaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 120.scale : 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 339.scale),
            imageView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 18.scale)
        ])
        
        NSLayoutConstraint.activate([
            loadingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            loadingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            loadingLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            progressView.heightAnchor.constraint(equalToConstant: 60.scale),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -97.scale : -37.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OPreloaderView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.semiBold(size: 16.scale))
            .lineHeight(22.4.scale)
            .textAlignment(.center)
            .letterSpacing(0.14.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Preloader.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white.withAlphaComponent(0.8))
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .textAlignment(.center)
            .letterSpacing(0.14.scale)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Preloader.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Preloader")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgresView() -> UIProgressView {
        let view = UIProgressView()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.trackTintColor = Appearance.white.withAlphaComponent(0.1)
        view.progressTintColor = UIColor(integralRed: 72, green: 113, blue: 92)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

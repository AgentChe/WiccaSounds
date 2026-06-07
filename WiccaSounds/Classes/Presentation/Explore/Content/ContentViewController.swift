//
//  ContentViewController.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 23.03.2023.
//

import UIKit
import RxSwift

final class ContentViewController: UIViewController {
    lazy var mainView = ContentView()
    
    private lazy var viewModel = ContentViewModel(source: unit)
    private let unit: ContentViewModel.Unit
    
    private lazy var disposeBag = DisposeBag()
    
    private init(unit: ContentViewModel.Unit) {
        self.unit = unit
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.tryAgain = { [weak self] error -> Observable<Void> in
            guard let self = self else {
                return .never()
            }
            
            return self.open(error: error)
        }
        
        mainView.closeButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        
        let didTapBookmark = mainView.bookmarkButton.rx.tap
            .withLatestFrom(viewModel.isSaved)
        
        didTapBookmark
            .bind(to: viewModel.didTapBookmark)
            .disposed(by: disposeBag)
        
        viewModel.isSaved
            .drive(Binder(self) { base, saved in
                base.update(bookmark: saved)
            })
            .disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: Make
extension ContentViewController {
    static func make(unit: ContentViewModel.Unit) -> ContentViewController {
        let vc = ContentViewController(unit: unit)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension ContentViewController {
    func update(bookmark: Bool) {
        let image = UIImage(named: bookmark ? "Content.Bookmark.Favorite" : "Content.Bookmark.Unfavorite")
        mainView.bookmarkButton.setImage(image, for: .normal)
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
                self.present(vc, animated: true)
                
                return Disposables.create()
            }
    }
}

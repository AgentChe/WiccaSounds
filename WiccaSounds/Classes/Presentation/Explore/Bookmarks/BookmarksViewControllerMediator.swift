//
//  BookmarksViewControllerMediator.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 14.04.2023.
//

import RxSwift
import RxCocoa

final class BookmarksViewControllerMediator {
    static let shared = BookmarksViewControllerMediator()
    
    private lazy var didTapDiscoverTrigger = PublishRelay<Void>()
    
    private init() {}
    
    func discoverTapped() {
        didTapDiscoverTrigger.accept(Void())
    }
    
    var didTapDiscover: Signal<Void> {
        didTapDiscoverTrigger.asSignal()
    }
}

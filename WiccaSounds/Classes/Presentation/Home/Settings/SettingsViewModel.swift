//
//  SettingsViewModel.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 14.04.2023.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    lazy var sections = makeSections()
}

// MARK: Private
private extension SettingsViewModel {
    func makeSections() -> Driver<[SettingsTableSection]> {
        Observable<[SettingsTableSection]>
            .create { event in
                let sections: [SettingsTableSection] = [
                    .init(elements: [.favoriteSpells]),
                    .init(elements: [
                        .contactUs,
                        .privacyPolice,
                        .termsOfUse
                    ])
                ]
                event.onNext(sections)
                
                return Disposables.create()
            }
            .asDriver(onErrorJustReturn: [])
    }
}

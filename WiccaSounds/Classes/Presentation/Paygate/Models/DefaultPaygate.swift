//
//  DefaultPaygate.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.02.2023.
//

import UIKit
import OtterScaleiOS

extension Paygate {
    init?(prices: [ProductPrice]) {
        guard
            let lifetimePrice = prices.first(where: { $0.id == GlobalDefinitions.Paygate.defaultLifetime }),
            let monthlyPrice = prices.first(where: { $0.id == GlobalDefinitions.Paygate.defaultMonthly })
        else {
            return nil
        }
        
        self = Paygate(
            topOptionConfig: Self.lifetime(
                lifetimePrice: lifetimePrice,
                monthlyPrice: monthlyPrice
            ),
            bottomOptionConfig: Self.monthly()
        )
    }
}

// MARK: Private
private extension Paygate {
    static func lifetime(lifetimePrice: ProductPrice, monthlyPrice: ProductPrice) -> PaygateOptionConfig {
        PaygateOptionConfig(
            productId: GlobalDefinitions.Paygate.defaultLifetime,
            title: "Paygate.Default.Lifetime.Title".localized,
            caption: "Paygate.Default.Lifetime.Caption".localized,
            div: 53,
            save: "SAVE 85%"
        )
    }
    
    static func monthly() -> PaygateOptionConfig {
        PaygateOptionConfig(
            productId: GlobalDefinitions.Paygate.defaultMonthly,
            title: "Paygate.Default.Monthly.Title".localized,
            caption: "Paygate.Default.Monthly.Caption".localized,
            div: nil,
            save: nil
        )
    }
}

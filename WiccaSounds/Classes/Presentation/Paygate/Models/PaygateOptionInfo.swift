//
//  PaygateOptionInfo.swift
//  Soccer
//
//  Created by Андрей Чернышев on 14.02.2023.
//

import UIKit

struct PaygateOptionInfo {
    let productId: String
    let title: String
    let caption: String
    let save: String?
    
    init(config: PaygateOptionConfig, price: ProductPrice) {
        productId = config.productId
        save = config.save
        
        let localizedPrice = price.priceLocalized
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = price.priceLocale
        formatter.roundingMode = .down
        
        let div = config.div ?? 1
        let priceDiv = price.priceValue / Double(div)
        if priceDiv < 100 {
            formatter.maximumFractionDigits = 2
        } else if priceDiv < 1000 {
            formatter.maximumFractionDigits = 1
        } else {
            formatter.maximumFractionDigits = 0
        }
        let localizedPriceDiv = formatter.string(from: NSNumber(value: priceDiv)) ?? ""
        
        let title = config.title
            .replacingOccurrences(of: "@price_div", with: localizedPriceDiv)
            .replacingOccurrences(of: "@price", with: localizedPrice)
        
        let caption = config.caption
            .replacingOccurrences(of: "@price_div", with: localizedPriceDiv)
            .replacingOccurrences(of: "@price", with: localizedPrice)
        
        self.title = title
        self.caption = caption
    }
}

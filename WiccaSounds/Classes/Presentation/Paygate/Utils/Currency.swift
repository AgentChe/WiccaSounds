//
//  Currency.swift
//  CodeChallenge
//
//  Created by Андрей Чернышев on 19.03.2024.
//

import Foundation

struct Currency {
    enum LTRCurrency: String, CaseIterable {
        case USD = "USD"
    }
    
    private let productPrice: ProductPrice
    private let div: Double
    
    init(productPrice: ProductPrice, div: Double = 1) {
        self.productPrice = productPrice
        self.div = div
    }
    
    func formatted() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = productPrice.priceLocale
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .down
        formatter.currencyCode = productPrice.currency
        
        let currencySymbol = formatter.currencySymbol ?? productPrice.currency
        
        formatter.currencyCode = ""
        formatter.currencySymbol = ""
        
        guard let resultPrice = formatter.string(from: NSNumber(value: productPrice.priceValue / div)) else {
            return nil
        }
        
        let ltrCurrencies = LTRCurrency.allCases.map { $0.rawValue }
        
        if ltrCurrencies.contains(productPrice.currency) {
            return String(format: "%@%@", currencySymbol, resultPrice)
        } else {
            return String(format: "%@%@", resultPrice, currencySymbol)
        }
    }
}


//
//  Date+Extension.swift
//  Soccer
//
//  Created by Андрей Чернышев on 11.03.2023.
//

import Foundation

extension Date {
    func isEqualByDays(with date: Date) -> Bool {
        Calendar.current.component(.day, from: self) == Calendar.current.component(.day, from: date)
    }
}

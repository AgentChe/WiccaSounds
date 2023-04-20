//
//  RuneTableElement.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 20.04.2023.
//

import Foundation

enum RuneTableElement {
    case name(String)
    case image(URL)
    case title(String)
    case text(String)
    case contentImage(URL)
    case tags([String])
}

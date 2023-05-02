//
//  ContentTableElement.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 23.03.2023.
//

import Foundation

enum ContentTableElement {
    case title(ContentTableTitle)
    case text(String)
    case image(ContentTableImage)
}

enum ContentTableTitle {
    case spell(String)
    case other(String)
}

struct ContentTableImage {
    let url: URL
    let withGradient: Bool
    
    init(url: URL, withGradient: Bool = false) {
        self.url = url
        self.withGradient = withGradient
    }
}

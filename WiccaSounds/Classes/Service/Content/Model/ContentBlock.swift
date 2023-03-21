//
//  ContentBlock.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

struct ContentBlock: Codable, Hashable {
    enum Content: Codable, Hashable {
        case text(String)
        case image(URL)
    }
    
    let id: Int
    let content: Content
}

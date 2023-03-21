//
//  ContentBlockMapper.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 21.03.2023.
//

import Foundation

enum ContentBlockMapper {
    static func map(from json: [String: Any]) -> ContentBlock? {
        guard
            let id = json["block_id"] as? Int,
            let content = json["content"] as? String,
            let type = json["type"] as? Int,
            let content = Self.content(at: type, value: content)
        else {
            return nil
        }
        
        return ContentBlock(
            id: id,
            content: content
        )
    }
}

// MARK: Private
private extension ContentBlockMapper {
    static func content(at type: Int, value: String) -> ContentBlock.Content? {
        switch type {
        case 1:
            return .text(value)
        case 2:
            guard let url = URL(string: value) else {
                return nil
            }
            
            return .image(url)
        default:
            return nil
        }
    }
}

//
//  URL+Extension.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 24.04.2023.
//

import Foundation.NSURL

extension URL {
    
    var localUrl: URL {
        transformedToLocal ?? self
    }
    
    var isContained: Bool {
        transformedToLocal != nil
    }
    
    var localPath: String {
        let string = absoluteString
        let type = String(string.split(separator: ".").last ?? "")
        let withoutType = String(string.dropLast(type.count + 1))
        return withoutType.replacingOccurrences(of: "/|:", with: "_", options: [.regularExpression])
            .replacingOccurrences(of: "%20", with: " ", options: [.regularExpression]) + "." + type
    }
    
    private var transformedToLocal: URL? {
        let string = absoluteString
        let type = String(string.split(separator: ".").last ?? "")
        let withoutType = String(string.dropLast(type.count + 1))
        let result = withoutType.replacingOccurrences(of: "/|:", with: "_", options: [.regularExpression])
            .replacingOccurrences(of: "%20", with: " ", options: [.regularExpression])
        
        if let local = Bundle.main.path(forResource: result, ofType: type) {
            return URL(fileURLWithPath: local)
        }
        let resultWithType = result + "." + type
        if let path = try? FileManager.default.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).path, FileManager.default.fileExists(atPath: path + "/" + resultWithType) {
            return URL(fileURLWithPath: path + "/" + resultWithType)
        }
        return nil
    }
}

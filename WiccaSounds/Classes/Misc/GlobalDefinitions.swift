//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://wiccaspells.org"
    static let apiKey = "7zEi2GUGqzdV74yCU2bl"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "vO76dtB8hszMliN5"
    
    static let appleAppID = "1516097125"
    
    static let applicationTag = "WICCA 2"
    static let amplitudeApiKey = "0d810afcbd45c0b58a5ed6cd272acfa"
    static let appsFlyerApiKey = "DCciCfYXjMQ8QnkdCg8qzk"
    
    static let termsOfServiceUrl = URL(string: "https://wiccaspells.org/terms")!
    static let privacyPolicyUrl = URL(string: "https://wiccaspells.org/policy")!
    static let contactUsUrl = URL(string: "https://wiccaspells.org/contact")!
    
    enum Paygate {
        static let yearly = "wicca.annually"
        static let weekly = "wicca.weekly"
    }
}

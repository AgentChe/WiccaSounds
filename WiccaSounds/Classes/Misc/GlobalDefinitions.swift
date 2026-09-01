//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://wicca2.thinkaboutapps.com"
    static let apiKey = "7zEi2GUGqzdV74yCU2bl"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "vO76dtB8hszMliN5"

    static let postHogHost = "https://posthog.korrekted.com"
    static let postHogApiKey = "phc_a29Kj3MGr3nLv9NN4WLZiRyHF5mluQZaPbVgcCbIqPa"
    
    static let termsOfServiceUrl = URL(string: "https://thinkaboutapps.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://thinkaboutapps.com/policy")!
    static let contactUsUrl = URL(string: "https://thinkaboutapps.com/contact")!
    
    enum Paygate {
        static let yearly = "wicca.annually"
        static let weekly = "wicca.weekly"
    }
}

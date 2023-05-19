//
//  AppsFlyerManager.swift
//  Soccer
//
//  Created by Андрей Чернышев on 11.01.2023.
//

import AppsFlyerLib
import UIKit
import OtterScaleiOS

final class AppsFlyerManager {
    static let shared = AppsFlyerManager()
    
    private init() {}
}

// MARK: OtterScaleReceiptValidationDelegate
extension AppsFlyerManager: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: AppStoreValidateResult?) {
        guard let otterScaleID = result?.externalUserID ?? result?.internalUserID else {
            return
        }
        
        guard otterScaleID != OtterScale.shared.getAnonymousID() else {
            return
        }
        
        set(userId: otterScaleID)
    }
}

// MARK: Public
extension AppsFlyerManager {
    func initialize() {
        AppsFlyerLib.shared().appsFlyerDevKey = GlobalDefinitions.appsFlyerApiKey
        AppsFlyerLib.shared().appleAppID = GlobalDefinitions.appleAppID
        
        OtterScale.shared.addReceiptValidation(delegate: self)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
    }
    
    func set(userId: String) {
        AppsFlyerLib.shared().customerUserID = userId
    }
}

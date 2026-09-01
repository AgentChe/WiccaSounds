//
//  PostHogManager.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 01.09.2026.
//

import PostHog
import OtterScaleiOS
import StoreKit

final class PostHogManager: NSObject {
    deinit {
        SKPaymentQueue.default().remove(self)
    }

    static let shared = PostHogManager()

    private enum PersonProperty {
        static let otterScaleInternalId = "otter_scale_internal_id"
        static let hasActiveSubscription = "has_active_subscription"
    }

    private lazy var sessionManager = SessionManager()

    private override init() {
        super.init()
    }
}

// MARK: OtterScaleReceiptValidationDelegate
extension PostHogManager: OtterScaleReceiptValidationDelegate {
    func otterScaleDidValidatedReceipt(with result: AppStoreValidateResult?) {
        identify()
    }
}

// MARK: SKPaymentTransactionObserver
extension PostHogManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        let purchased = transactions
            .filter { $0.transactionState == .purchased }

        guard !purchased.isEmpty else {
            return
        }

        logEvent(name: "client_subscription_or_purchase")
    }
}

// MARK: Public
extension PostHogManager {
    func initialize() {
        let configuration = PostHogConfig(
            projectToken: GlobalDefinitions.postHogApiKey,
            host: GlobalDefinitions.postHogHost
        )

        PostHogSDK.shared.setup(configuration)

        identify()

        OtterScale.shared.addReceiptValidation(delegate: self)
        SKPaymentQueue.default().add(self)

        installFirstLaunchIfNeeded()
    }

    func logEvent(name: String, parameters: [String: Any] = [:]) {
        PostHogSDK.shared.capture(name, properties: parameters)
    }
}

// MARK: Private
private extension PostHogManager {
    func identify() {
        let distinctId = OtterScale.shared.getAnonymousID()

        guard !distinctId.isEmpty else {
            return
        }

        PostHogSDK.shared.identify(distinctId, userProperties: [
            PersonProperty.otterScaleInternalId: OtterScale.shared.getInternalID(),
            PersonProperty.hasActiveSubscription: sessionManager.hasActiveSubscriptions()
        ])
    }

    func installFirstLaunchIfNeeded() {
        guard NumberLaunches().isFirstLaunch() else {
            return
        }

        logEvent(name: "client_first_launch")
    }
}

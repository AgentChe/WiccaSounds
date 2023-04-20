//
//  ReviewElement.swift
//  WiccaSounds
//
//  Created by Андрей Чернышев on 19.04.2023.
//

struct ReviewElement {
    let image: String
    let text: String
}

// MARK: Public
extension ReviewElement {
    static func makeCollection() -> [ReviewElement] {
        [
            ReviewElement(
                image: "Paygate.Review.1",
                text: "Paygate.Review.1.Text".localized
            ),
            ReviewElement(
                image: "Paygate.Review.2",
                text: "Paygate.Review.2.Text".localized
            ),
            ReviewElement(
                image: "Paygate.Review.3",
                text: "Paygate.Review.3.Text".localized
            ),
            ReviewElement(
                image: "Paygate.Review.4",
                text: "Paygate.Review.4.Text".localized
            ),
            ReviewElement(
                image: "Paygate.Review.5",
                text: "Paygate.Review.5.Text".localized
            ),
            ReviewElement(
                image: "Paygate.Review.6",
                text: "Paygate.Review.6.Text".localized
            ),
            ReviewElement(
                image: "Paygate.Review.7",
                text: "Paygate.Review.7.Text".localized
            ),
            ReviewElement(
                image: "Paygate.Review.8",
                text: "Paygate.Review.8.Text".localized
            ),
            ReviewElement(
                image: "Paygate.Review.9",
                text: "Paygate.Review.9.Text".localized
            ),
            ReviewElement(
                image: "Paygate.Review.10",
                text: "Paygate.Review.10.Text".localized
            )
        ]
    }
}

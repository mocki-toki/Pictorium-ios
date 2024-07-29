//
//  AlertPresenter.swift
//  Pictorium
//
//  Created by Simon Butenko on 20.07.2024.
//

import UIKit

protocol AlertPresenterProtocol {
    func show(title: String, message: String?, buttons: [(title: String, action: (() -> Void)?)])
}

final class AlertPresenter: AlertPresenterProtocol {
    // MARK: - Public Properties

    private weak var viewController: UIViewController?

    // MARK: - Initializers

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }

    // MARK: - Public Methods

    func show(title: String, message: String?, buttons: [(title: String, action: (() -> Void)?)]) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.view.accessibilityIdentifier = "Alert"

        for button in buttons {
            let alertAction = UIAlertAction(title: button.title, style: .default) { _ in
                button.action?()
            }
            alert.addAction(alertAction)
        }

        viewController?.present(alert, animated: true, completion: nil)
    }
}

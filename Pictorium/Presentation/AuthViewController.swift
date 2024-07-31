//
//  AuthViewController.swift
//  Pictorium
//
//  Created by Simon Butenko on 13.05.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ viewController: AuthViewController)
}

final class AuthViewController: UIViewController {
    // MARK: - Public Properties

    weak var delegate: AuthViewControllerDelegate?

    // MARK: - Private Properties

    private var alertPresenter: AlertPresenterProtocol?
    private let oauthService = OAuth2Service.shared

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)

        configureBackButton()
    }

    // MARK: - Public Methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let webViewVC = segue.destination as? WebViewViewController {
            webViewVC.delegate = self
        }
    }

    // MARK: - Private Methods

    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage.backward
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.backward
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.ypBlack
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ viewController: WebViewViewController, didAuthenticateWithCode code: String) {
        viewController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.oauthService.fetchOAuthToken(with: code) { result in
                switch result {
                case .success(let token):
                    print("Successfully fetched token: \(token)")
                    self.delegate?.didAuthenticate(self)
                case .failure(let error):
                    print("Failed to fetch token: \(error)")
                    self.alertPresenter?.show(
                        title: "Что-то пошло не так",
                        message: "Не удалось войти в систему",
                        buttons: [("Ок", nil)]
                    )
                }
            }
        }
    }

    func webViewViewControllerDidCancel(_ viewController: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
}

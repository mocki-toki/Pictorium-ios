//
//  AuthViewController.swift
//  Pictorium
//
//  Created by Simon Butenko on 13.05.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    private let oauthService = OAuth2Service()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }

    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage.backward
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.backward
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.ypBlack
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let webViewVC = segue.destination as? WebViewViewController {
            webViewVC.delegate = self
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.oauthService.fetchOAuthToken(with: code) { result in
                switch result {
                case .success(let token):
                    print("Successfully fetched token: \(token)")
                    self.delegate?.didAuthenticate(self)
                case .failure(let error):
                    print("Failed to fetch token: \(error)")
                }
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
}

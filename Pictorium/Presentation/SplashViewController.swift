//
//  SplashViewController.swift
//  Pictorium
//
//  Created by Simon Butenko on 21.05.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: - Private Properties

    private let storage = OAuth2TokenStorage()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.practicumLogo
        return imageView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if storage.token != nil {
            switchToTabBarController()
        } else {
            presentAuthViewController()
        }
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .ypBlack

        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 75)
        ])
    }

    private func switchToTabBarController() {
        ProfileService.shared.fetchProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { result in
                    switch result {
                    case .success:
                        self.presentTabBarController()
                    case .failure:
                        print("Failed to fetch profile image URL")
                    }
                }
            case .failure:
                print("Failed to fetch profile")
            }
        }
    }

    private func presentTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }

    private func presentAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(
            withIdentifier: "AuthViewController"
        ) as? AuthViewController
        else {
            assertionFailure("AuthViewController not found in storyboard")
            return
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ viewController: AuthViewController) {
        viewController.dismiss(animated: true) {
            self.switchToTabBarController()
        }
    }
}

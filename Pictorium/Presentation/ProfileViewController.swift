//
//  ProfileViewController.swift
//  Pictorium
//
//  Created by Simon Butenko on 18.03.2024.
//
import Kingfisher
import UIKit

enum ProfileViewControllerFactory {
    static func makeController() -> ProfileViewController {
        let viewController = ProfileViewController()

        let presenter = ProfilePresenter(
            profileService: ProfileService.shared,
            profileImageService: ProfileImageService.shared,
            logoutService: ProfileLogoutService.shared
        )

        viewController.presenter = presenter
        presenter.view = viewController

        return viewController
    }
}

protocol ProfileViewControllerProtocol: AnyObject {
    func updateProfileDetails(profile: Profile)
    func updateAvatar(url: URL)
    func showLogoutAlert(completion: @escaping () -> Void)
}

final class ProfileViewController: UIViewController {
    // MARK: - Properties

    var presenter: ProfilePresenterProtocol!

    // MARK: - UI Components

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.backgroundColor = .ypGray
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.accessibilityIdentifier = "First name Last name"
        return label
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypGray
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.accessibilityIdentifier = "Username"
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    lazy var exitButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage.exit, target: self, action: #selector(exitButtonTapped))
        button.tintColor = .ypRed
        button.accessibilityIdentifier = "Logout button"
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.viewDidLoad()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .ypBlack

        for item in [profileImageView, nameLabel, usernameLabel, descriptionLabel, exitButton] {
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),

            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),

            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),

            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }

    @objc private func exitButtonTapped() {
        presenter.didTapExitButton()
    }
}

// MARK: - ProfileViewControllerProtocol

extension ProfileViewController: ProfileViewControllerProtocol {
    func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        usernameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }

    func updateAvatar(url: URL) {
        profileImageView.kf.setImage(with: url)
    }

    func showLogoutAlert(completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Да", style: .destructive) { _ in
            completion()
        })

        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))

        present(alert, animated: true)
    }
}

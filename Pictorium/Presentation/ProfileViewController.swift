//
//  ProfileViewController.swift
//  Pictorium
//
//  Created by Simon Butenko on 18.03.2024.
//
import Kingfisher
import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Private Properties

    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter: AlertPresenterProtocol?

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.backgroundColor = .ypGray
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return label
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypGray
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()

    private let exitButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage.exit, target: nil, action: nil)
        button.tintColor = .ypRed
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)

        view.backgroundColor = .ypBlack
        updateProfile()
        updateAvatar()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(profileDidChange(_:)),
            name: ProfileService.didChangeNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(profileImageDidChange(_:)),
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
    }

    @objc private func profileDidChange(_ notification: Notification) {
        updateProfile()
    }

    @objc private func profileImageDidChange(_ notification: Notification) {
        updateAvatar()
    }

    // MARK: - Private Methods

    private func setupViews(_ profile: Profile) {
        [
            profileImageView,
            nameLabel,
            usernameLabel,
            descriptionLabel,
            exitButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        configureProfileImageView(username: profile.username)
        configureNameLabel(value: profile.name)
        configureUsernameLabel(value: profile.loginName)
        configureDescriptionLabel(value: profile.bio)
        configureExitButton()
    }

    private func configureProfileImageView(username: String) {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func configureNameLabel(value name: String) {
        nameLabel.text = name
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8)
        ])
    }

    private func configureUsernameLabel(value username: String) {
        usernameLabel.text = username
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }

    private func configureDescriptionLabel(value description: String) {
        descriptionLabel.text = description
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8)
        ])
    }

    private func configureExitButton() {
        exitButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }

    @objc private func buttonTapped() {
        alertPresenter?.show(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            buttons: [
                ("Да", {
                    ProfileLogoutService.shared.logout()
                    guard let window = UIApplication.shared.windows.first else {
                        assertionFailure("Invalid window configuration")
                        return
                    }
                    window.rootViewController = SplashViewController()
                }),
                ("Нет", nil)
            ]
        )
    }

    private func updateAvatar() {
        guard let url = ProfileImageService.shared.avatarURL else { return }

        profileImageView.kf.setImage(with: url) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("Download image failed: \(error)")
            }
        }
    }

    private func updateProfile() {
        guard let profile = ProfileService.shared.profile else { return }

        setupViews(profile)
    }
}

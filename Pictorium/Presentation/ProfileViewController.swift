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

    private var profileImageServiceObserver: NSObjectProtocol?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack

        loadMeResponseBody { profile in
            self.setupViews(profile)
            self.loadProfileImage(for: profile.username)
        }

        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
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
        NSLayoutConstraint.activate([
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }

    private func loadMeResponseBody(completion: @escaping (_ profile: Profile) -> Void) {
        return profileService.fetchProfile { result in
            switch result {
            case .success(let profile):
                self.nameLabel.text = profile.name
                self.usernameLabel.text = profile.loginName
                self.descriptionLabel.text = profile.bio
                completion(profile)
            case .failure(let error):
                print("Failed to load data: \(error)")
            }
        }
    }

    private func loadProfileImage(for username: String) {
        profileImageService.fetchProfileImageURL(username: username) { _ in }
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
}

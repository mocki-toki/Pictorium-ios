//
//  ProfilePresenter.swift
//  Pictorium
//
//  Created by Simon Butenko on 31.07.2024.
//

import UIKit

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapExitButton()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    private let logoutService: ProfileLogoutService

    init(profileService: ProfileService, profileImageService: ProfileImageService, logoutService: ProfileLogoutService) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.logoutService = logoutService
    }

    func viewDidLoad() {
        updateProfile()
        updateAvatar()
    }

    func didTapExitButton() {
        view?.showLogoutAlert { [weak self] in
            self?.logout()
        }
    }

    private func updateProfile() {
        guard let profile = profileService.profile else { return }
        view?.updateProfileDetails(profile: profile)
    }

    private func updateAvatar() {
        guard let url = profileImageService.avatarURL else { return }
        view?.updateAvatar(url: url)
    }

    private func logout() {
        logoutService.logout()
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        window.rootViewController = SplashViewController()
    }
}

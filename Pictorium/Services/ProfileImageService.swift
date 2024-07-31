//
//  ProfileImageService.swift
//  Pictorium
//
//  Created by Simon Butenko on 15.07.2024.
//

import Foundation

final class ProfileImageService {
    private init() {}

    // MARK: - Private Properties

    private let session: URLSession = .shared
    private let tokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private(set) var avatarURL: URL?

    // MARK: - Public Properties

    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    // MARK: - Public Methods

    func cleanProfileImageURL() {
        avatarURL = nil
        NotificationCenter.default.post(
            name: ProfileImageService.didChangeNotification,
            object: self)
    }

    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<URL, Error>) -> Void) {
        onMainThread {
            self.task?.cancel()

            guard let request = self.createUserRequest(username: username) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            UIBlockingProgressHUD.show()
            self.task = self.session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
                self?.task = nil
                UIBlockingProgressHUD.dismiss()

                switch result {
                case .success(let result):
                    let profileImageURL = result.profileImage.small
                    self?.avatarURL = profileImageURL
                    completion(.success(result.profileImage.small))

                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self)
                case .failure(let error):
                    print("ProfileImageService failure: \(error)")
                    completion(.failure(error))
                }
            }

            self.task?.resume()
        }
    }

    // MARK: - Private Methods

    private func createUserRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "\(APIConfig.apiURL)/users/\(username)") else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setToken(tokenStorage.token)

        return request
    }
}

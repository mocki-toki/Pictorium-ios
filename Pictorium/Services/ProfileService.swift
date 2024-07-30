//
//  ProfileService.swift
//  Pictorium
//
//  Created by Simon Butenko on 12.07.2024.
//

import Foundation

final class ProfileService {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileProviderDidChange")
    static let shared = ProfileService()
    private init() {}

    // MARK: - Properties

    private let session: URLSession = .shared
    private let tokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private(set) var profile: Profile?

    // MARK: - Public Methods

    func cleanProfile() {
        profile = nil
        NotificationCenter.default.post(
            name: ProfileService.didChangeNotification,
            object: self)
    }

    func fetchProfile(_ completion: @escaping (Result<Profile, Error>) -> Void) {
        onMainThread {
            self.task?.cancel()

            guard let request = self.createMeRequest() else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            UIBlockingProgressHUD.show()
            self.task = self.session.objectTask(for: request) { [weak self] (result: Result<MeResult, Error>) in
                self?.task = nil
                UIBlockingProgressHUD.dismiss()

                switch result {
                case .success(let result):
                    let profile = Profile(from: result)
                    self?.profile = profile
                    completion(.success(profile))

                    NotificationCenter.default.post(
                        name: ProfileService.didChangeNotification,
                        object: self)
                case .failure(let error):
                    print("ProfileService failure: \(error)")
                    completion(.failure(error))
                }
            }

            self.task?.resume()
        }
    }

    // MARK: - Private Methods

    private func createMeRequest() -> URLRequest? {
        guard let url = URL(string: "\(APIConfig.defaultBaseURL)/me") else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setToken(tokenStorage.token)

        return request
    }
}

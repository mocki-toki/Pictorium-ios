//
//  OAuth2Service.swift
//  Pictorium
//
//  Created by Simon Butenko on 21.05.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}

    // MARK: - Properties

    private let session: URLSession = .shared
    private let tokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private var lastCode: String?

    // MARK: - Public Methods

    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard lastCode != code else {
            completion(.failure(NSError(domain: "Duplicate request", code: 0, userInfo: nil)))
            return
        }

        onMainThread {
            self.task?.cancel()
            self.lastCode = code

            guard let request = self.createTokenRequest(with: code) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }

            UIBlockingProgressHUD.show()
            self.task = self.session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResult, Error>) in
                self?.task = nil
                self?.lastCode = nil
                UIBlockingProgressHUD.dismiss()

                switch result {
                case .success(let result):
                    let token = result.accessToken

                    self?.tokenStorage.token = token
                    completion(.success(token))
                case .failure(let error):
                    print("OAuth2Service failure: \(error)")
                    completion(.failure(error))
                }
            }

            self.task?.resume()
        }
    }

    // MARK: - Private Methods

    private func createTokenRequest(with code: String) -> URLRequest? {
        guard let url = URL(string: "https://unsplash.com/oauth/token") else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let parameters: [String: String] = [
            "client_id": APIConfig.accessKey,
            "client_secret": APIConfig.secretKey,
            "redirect_uri": APIConfig.redirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]

        request.httpBody = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)

        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        return request
    }
}

//
//  OAuth2Service.swift
//  Pictorium
//
//  Created by Simon Butenko on 21.05.2024.
//

import Foundation

final class OAuth2Service {
    // MARK: - Properties

    private let session: URLSession = .shared
    private let tokenStorage = OAuth2TokenStorage()

    // MARK: - Public Methods

    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = createTokenRequest(with: code) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        let task = session.data(for: request) { result in

            switch result {
            case .success(let data):
                do {
                    let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    let token = responseBody.accessToken
                    self.tokenStorage.token = token
                    completion(.success(token))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Network error: \(error)")
                completion(.failure(error))
            }
        }

        task.resume()
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

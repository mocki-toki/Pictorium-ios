//
//  APIConfig.swift
//  Pictorium
//
//  Created by Simon Butenko on 21.05.2024.
//

import Foundation

enum APIConfig {
    static let accessKey = "fdkdHhIzxO91Jacsxj5SLWfusgSBZshuBdCJSVUmQwU"
    static let secretKey = "nyY8o9Ts_LZjc7n9cMh8P6baGcL2PrY0BRvP_zeUbwA"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"

    static let defaultBaseURL = "https://api.unsplash.com"
    static let authURL = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: String
    let authURL: String

    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        defaultBaseURL: String,
        authURL: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURL = authURL
    }

    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: APIConfig.accessKey,
            secretKey: APIConfig.secretKey,
            redirectURI: APIConfig.redirectURI,
            accessScope: APIConfig.accessScope,
            defaultBaseURL: APIConfig.defaultBaseURL,
            authURL: APIConfig.authURL)
    }
}

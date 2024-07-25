//
//  OAuth2TokenStorage.swift
//  Pictorium
//
//  Created by Simon Butenko on 21.05.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let keychain = KeychainWrapper.standard
    private let tokenKey = KeychainWrapper.Key("OAuth2AccessToken")

    var token: String? {
        get {
            keychain.string(forKey: tokenKey)
        }
        set {
            guard let newValue else {
                keychain.remove(forKey: tokenKey)
                return
            }

            keychain.set(newValue, forKey: tokenKey.rawValue)
        }
    }
}

//
//  APIConfig.swift
//  Pictorium
//
//  Created by Simon Butenko on 21.05.2024.
//

import Foundation

enum APIConfig {
    static let accessKey = "49pS5vqk7xY3GGFjJXMhrcUsOYI_J9hYDu_ke8i2c2M"
    static let secretKey = "rRhjRYORQKpXbh-X3-kVuAYzr577iQHcMp04GDBwX9s"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let authorizeURL = "https://unsplash.com/oauth/authorize"
    static let apiURL = "https://api.unsplash.com"
}

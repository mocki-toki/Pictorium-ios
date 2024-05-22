//
//  OAuthTokenResponseBody.swift
//  Pictorium
//
//  Created by Simon Butenko on 21.05.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Date
}

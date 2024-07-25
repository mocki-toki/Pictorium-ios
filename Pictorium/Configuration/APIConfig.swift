//
//  APIConfig.swift
//  Pictorium
//
//  Created by Simon Butenko on 21.05.2024.
//

import Foundation

enum APIConfig {
    static let accessKey = "m32EiMlnjEswX-dGQV6B0_Ua7DsdcmX8baB4bJ0I3TU"
    static let secretKey = "myDePsiCf5I_dKFv_kgRHhLTdo_vB3awJCGeJpurKnM"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let authorizeURL = "https://unsplash.com/oauth/authorize"
    static let apiURL = "https://api.unsplash.com"
}

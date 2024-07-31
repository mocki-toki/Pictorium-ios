//
//  UserResult.swift
//  Pictorium
//
//  Created by Simon Butenko on 15.07.2024.
//

import Foundation

struct UserResultProfileImage: Decodable {
    let small: URL
}

struct UserResult: Decodable {
    let profileImage: UserResultProfileImage
}

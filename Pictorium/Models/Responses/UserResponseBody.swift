//
//  UserResponseBody.swift
//  Pictorium
//
//  Created by Simon Butenko on 15.07.2024.
//

import Foundation

struct UserResponseBodyProfileImage: Decodable {
    let small: URL
}

struct UserResponseBody: Decodable {
    let profileImage: UserResponseBodyProfileImage
}

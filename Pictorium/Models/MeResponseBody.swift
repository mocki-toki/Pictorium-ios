//
//  MeResponseBody.swift
//  Pictorium
//
//  Created by Simon Butenko on 12.07.2024.
//

import Foundation

struct MeResponseBody: Decodable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
}

//
//  PhotoResponseBody.swift
//  Pictorium
//
//  Created by Simon Butenko on 26.07.2024.
//

import Foundation

struct PhotoResponseBody: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let color: String
    let blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let user: UserResponseBody
    let urls: URLs
}

struct URLs: Decodable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
}

//
//  Photo.swift
//  Pictorium
//
//  Created by Simon Butenko on 26.07.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date
    let welcomeDescription: String?
    let thumbImageURL: URL
    let largeImageURL: URL
    let isLiked: Bool
}

extension Photo {
    init(from responseBody: PhotoResponseBody) {
        let dateFormatter = ISO8601DateFormatter()

        self.id = responseBody.id
        self.size = CGSize(width: responseBody.width, height: responseBody.height)
        self.createdAt = dateFormatter.date(from: responseBody.createdAt)!
        self.welcomeDescription = responseBody.description
        self.thumbImageURL = responseBody.urls.small
        self.largeImageURL = responseBody.urls.full
        self.isLiked = responseBody.likedByUser
    }

    init(from responseBody: ChangeLikePhotoResponseBody) {
        self.init(from: responseBody.photo)
    }
}

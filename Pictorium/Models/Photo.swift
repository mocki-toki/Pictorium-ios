//
//  Photo.swift
//  Pictorium
//
//  Created by Simon Butenko on 26.07.2024.
//

import Foundation

struct Photo: Equatable {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: URL
    let largeImageURL: URL
    let isLiked: Bool

    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Photo {
    init(from result: PhotoResult) {
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        self.createdAt = iso8601DateFormatter.date(from: result.createdAt ?? "")
        self.welcomeDescription = result.description
        self.thumbImageURL = result.urls.small
        self.largeImageURL = result.urls.small
        self.isLiked = result.likedByUser
    }

    init(from result: ChangeLikePhotoResult) {
        self.init(from: result.photo)
    }
}

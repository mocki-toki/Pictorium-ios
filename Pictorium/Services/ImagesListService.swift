//
//  ImagesListService.swift
//  Pictorium
//
//  Created by Simon Butenko on 26.07.2024.
//

import Foundation

protocol ImagesListServiceProtocol: AnyObject {
    var photos: [Photo] { get }
    func fetchPhotosNextPage()
}

final class ImagesListService: ImagesListServiceProtocol {
    // MARK: - Private Properties

    private let session: URLSession = .shared
    private let tokenStorage = OAuth2TokenStorage()
    private var fetchPhotosTask: URLSessionTask?
    private var likedPhotoId: String?

    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?

    // MARK: - Public Properties

    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    // MARK: - Public Methods

    func cleanPhotos() {
        photos.removeAll()
        NotificationCenter.default.post(
            name: ImagesListService.didChangeNotification,
            object: self)
    }

    func fetchPhotosNextPage() {
        onMainThread {
            guard self.fetchPhotosTask == nil else { return }

            let nextPage = (self.lastLoadedPage ?? 0) + 1
            guard let request = self.createPhotosRequest(page: nextPage) else {
                print("ImagesListService fetchPhotosNextPage failure: Invalid URL")
                return
            }

            self.fetchPhotosTask =
                self.session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
                    self?.fetchPhotosTask = nil

                    switch result {
                    case .success(let result):
                        let photos = result.map { Photo(from: $0) }
                        self?.photos.append(contentsOf: photos)
                        self?.lastLoadedPage = nextPage

                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: self)
                    case .failure(let error):
                        print("ImagesListService fetchPhotosNextPage failure: \(error)")
                    }
                }

            self.fetchPhotosTask?.resume()
        }
    }

    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        if likedPhotoId == photoId { return }
        onMainThread {
            guard let request = self.createLikeRequest(photoId: photoId, isLike: isLike) else {
                print("ImagesListService changeLike failure: Invalid URL")
                return
            }

            self.likedPhotoId = photoId
            let changeLikeTask =
                self.session.objectTask(for: request) { [weak self] (result: Result<ChangeLikePhotoResult, Error>) in
                    guard let self = self else { return }

                    self.likedPhotoId = nil
                    switch result {
                    case .success(let result):
                        let photo = Photo(from: result)
                        completion(.success(photo))

                        if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
                            self.photos[index] = photo

                            NotificationCenter.default.post(
                                name: ImagesListService.didChangeNotification,
                                object: self)
                        }
                    case .failure(let error):
                        completion(.failure(error))
                        print("ImagesListService changeLike failure: \(error)")
                    }
                }

            changeLikeTask.resume()
        }
    }

    // MARK: - Private Methods

    private func createPhotosRequest(page: Int) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "\(APIConfig.defaultBaseURL)/photos") else {
            return nil
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]

        guard let url = urlComponents.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setToken(tokenStorage.token)
        return request
    }

    private func createLikeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        guard let url = URL(string: "\(APIConfig.defaultBaseURL)/photos/\(photoId)/like") else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"

        request.setToken(tokenStorage.token)
        return request
    }
}

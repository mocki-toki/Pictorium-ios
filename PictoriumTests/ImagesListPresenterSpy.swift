//
//  ImagesListPresenterSpy.swift
//  Pictorium
//
//  Created by Simon Butenko on 31.07.2024.
//

import Foundation
@testable import Pictorium

class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var photos: [Photo] = []

    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled = false
    var didFetchPhotosCalled = false
    var fetchPhotosNextPageCalled = false
    var configureCellCalled = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didFetchPhotos() {
        didFetchPhotosCalled = true
    }

    func getPhotos() -> [Photo] {
        return photos
    }

    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }

    func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        configureCellCalled = true
    }

    func getPhoto(at index: Int) -> Photo? {
        return photos[safe: index]
    }
}

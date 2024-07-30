//
//  ImagesListPresenter.swift
//  Pictorium
//
//  Created by Simon Butenko on 31.07.2024.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func viewDidLoad()
    func fetchPhotosNextPage()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private let service: ImagesListServiceProtocol
    private(set) var photos: [Photo] = []

    init(service: ImagesListServiceProtocol) {
        self.service = service
    }

    func viewDidLoad() {
        view?.displayShimmerEffect()
        fetchPhotosNextPage()
        setupObserver()
    }

    func fetchPhotosNextPage() {
        service.fetchPhotosNextPage()
    }

    private func setupObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(imagesListDidChange),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
    }

    @objc private func imagesListDidChange() {
        let oldCount = photos.count
        photos = service.photos
        let newCount = photos.count

        if oldCount != newCount {
            view?.updateTableViewAnimated()
        }

        view?.hideShimmerEffect()
        view?.showTableView()
    }
}

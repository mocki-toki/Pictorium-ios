//
//  ImagesListViewController.swift
//  Pictorium
//
//  Created by Simon Butenko on 02.03.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    // MARK: - Constants

    private let showSingleImageSegueIdentifier = "ShowSingleImage"

    // MARK: - IBOutlets

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var shimmerContainerView: UIView!

    // MARK: - Private Properties

    private let service = ImagesListService.shared
    private var photos: [Photo] = []

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

        displayShimmerEffect()
        service.fetchPhotosNextPage()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(imagesListDidChange(_:)),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
    }

    @objc private func imagesListDidChange(_ notification: Notification) {
        updateTableViewAnimated()
        shimmerContainerView.isHidden = true
        tableView.isHidden = false
        updateTableViewAnimated()
    }

    func updateTableViewAnimated() {
        let oldPhotos = photos
        let newPhotos = service.photos
        photos = newPhotos

        let oldCount = oldPhotos.count
        let newCount = newPhotos.count

        var insertIndexPaths = [IndexPath]()
        var deleteIndexPaths = [IndexPath]()

        if oldCount < newCount {
            insertIndexPaths = (oldCount ..< newCount).map { IndexPath(row: $0, section: 0) }
        } else if oldCount > newCount {
            deleteIndexPaths = (newCount ..< oldCount).map { IndexPath(row: $0, section: 0) }
        }

        tableView.performBatchUpdates {
            if !deleteIndexPaths.isEmpty {
                tableView.deleteRows(at: deleteIndexPaths, with: .automatic)
            }
            if !insertIndexPaths.isEmpty {
                tableView.insertRows(at: insertIndexPaths, with: .automatic)
            }
        } completion: { _ in }
    }

    private func displayShimmerEffect() {
        let shimmerViews = createShimmerViews()
        let stackView = UIStackView(arrangedSubviews: shimmerViews)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill

        shimmerContainerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: shimmerContainerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: shimmerContainerView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: shimmerContainerView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: shimmerContainerView.bottomAnchor, constant: -16)
        ])
    }

    private func createShimmerViews() -> [UIView] {
        let heights: [CGFloat] = [370, 252, 230, 310, 400]

        return heights.map { height in
            let shimmerView = ShimmerView()
            shimmerView.translatesAutoresizingMaskIntoConstraints = false
            shimmerView.heightAnchor.constraint(equalToConstant: height).isActive = true
            return shimmerView
        }
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = service.photos[safe: indexPath.row] else { return 0 }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == service.photos.count {
            service.fetchPhotosNextPage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }

            guard let photo = service.photos[safe: indexPath.row] else {
                assertionFailure("Invalid photo")
                return
            }

            viewController.photo = photo
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        service.photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        if let photo = service.photos[safe: indexPath.row] {
            imageListCell.configure(with: indexPath, show: photo)
        }

        return imageListCell
    }
}

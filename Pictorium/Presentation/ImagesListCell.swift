//
//  ImagesListCell.swift
//  Pictorium
//
//  Created by Simon Butenko on 03.03.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - Constants

    static let reuseIdentifier = "ImagesListCell"

    // MARK: - Private Properties

    private let service = ImagesListService.shared
    private var likeIsChanging = false
    private var photo: Photo?
    private var isLiked: Bool {
        set {
            likeButton.setImage(newValue ? .favoritesActive : .favoritesNoActive, for: .normal)
        }
        get {
            likeButton.imageView?.image == UIImage.favoritesActive
        }
    }

    // MARK: - IBOutlets

    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!

    // MARK: - Public Methods

    func configure(with indexPath: IndexPath, show photo: Photo) {
        self.photo = photo

        dateLabel.text = photo.createdAt.formatToString()
        isLiked = photo.isLiked

        cellImage.kf.indicatorType = .custom(indicator: CustomActivityIndicator(frame: .zero))
        cellImage.kf.setImage(with: photo.thumbImageURL) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("Load image error: \(error)")
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }

    // MARK: - Actions

    @IBAction private func didTabLikeButton(_ sender: Any) {
        if likeIsChanging { return }
        guard let photo = photo else { return }

        likeIsChanging = true
        isLiked.toggle()
        service.changeLike(photoId: photo.id, isLike: isLiked) { [weak self] result in
            guard let self = self else { return }
            self.likeIsChanging = false

            switch result {
            case .success(let photo):
                self.isLiked = photo.isLiked
            case .failure:
                break
            }
        }
    }
}

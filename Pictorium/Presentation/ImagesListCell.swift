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

    // MARK: - IBOutlets

    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!

    // MARK: - Public Methods

    func configure(with indexPath: IndexPath, image: UIImage) {
        cellImage.image = image
        dateLabel.text = Date().formatToString()

        let likeIcon = indexPath.row % 2 == 0 ? UIImage.favoritesActive : UIImage.favoritesNoActive
        likeButton.setImage(likeIcon, for: .normal)
    }
}

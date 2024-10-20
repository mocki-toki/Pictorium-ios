//
//  SingleImageViewController.swift
//  Pictorium
//
//  Created by Simon Butenko on 17.04.2024.
//

import Kingfisher
import UIKit

final class SingleImageViewController: UIViewController {
    // MARK: - Public Properties

    var photo: Photo? {
        didSet {
            guard isViewLoaded else { return }
            loadImage()
        }
    }

    // MARK: - IBOutlets

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var didTapBackButton: UIButton!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var shareButton: UIButton!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        shareButton.isHidden = true
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self

        if photo != nil {
            loadImage()
        }
    }

    // MARK: - IBActions

    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }

    // MARK: - Private Methods

    private func loadImage() {
        guard let url = photo?.largeImageURL else { return }
        UIBlockingProgressHUD.show()

        imageView.kf.setImage(with: url) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()

            switch result {
            case .success(let value):
                self.shareButton.isHidden = false
                self.rescaleAndCenterImageInScrollView(image: value.image)
            case .failure(let error):
                self.showErrorAlert(with: error)
            }
        }
    }

    private func showErrorAlert(with error: KingfisherError) {
        let alertController = UIAlertController(
            title: "Ошибка загрузки",
            message: "Не удалось загрузить изображение. Попробуйте еще раз позже.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)

        print("Load image error: \(error)")
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        centerImage()
    }

    private func centerImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageSize = imageView.frame.size

        let verticalPadding = imageSize.height < scrollViewSize.height ?
            (scrollViewSize.height - imageSize.height) / 2 : 0
        let horizontalPadding = imageSize.width < scrollViewSize.width ?
            (scrollViewSize.width - imageSize.width) / 2 : 0

        scrollView.contentInset = UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding
        )
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}

//
//  SingleImageViewController.swift
//  Pictorium
//
//  Created by Simon Butenko on 17.04.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    // MARK: - Public Properties

    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }

            imageView.image = image
            guard let image = image else { return }

            rescaleAndCenterImageInScrollView(image: image)
            imageView.frame.size = image.size
        }
    }

    // MARK: - IBOutlet

    @IBOutlet private var imageView: UIImageView!

    @IBOutlet private var didTapBackButton: UIButton!

    @IBOutlet private var scrollView: UIScrollView!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        guard let image = image else { return }

        rescaleAndCenterImageInScrollView(image: image)
        imageView.frame.size = image.size

        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }

    // MARK: - IBAction

    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }

    // MARK: - Private Methods

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
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

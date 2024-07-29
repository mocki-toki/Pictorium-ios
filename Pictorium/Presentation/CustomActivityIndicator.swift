//
//  CustomActivityIndicator.swift
//  Pictorium
//
//  Created by Simon Butenko on 26.07.2024.
//

import Kingfisher
import UIKit

class CustomActivityIndicator: UIView, Indicator {
    private var imageView: UIImageView?

    var view: IndicatorView {
        return self
    }

    func startAnimatingView() {
        isHidden = false
        startOpacityAnimation()
    }

    func stopAnimatingView() {
        isHidden = true
        imageView?.layer.removeAnimation(forKey: "opacityAnimation")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
    }

    private func setupImageView() {
        let image = UIImage.stub
        imageView = UIImageView(image: image)
        imageView?.contentMode = .scaleAspectFit
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView!)

        NSLayoutConstraint.activate([
            imageView!.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView!.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView!.widthAnchor.constraint(equalToConstant: 50),
            imageView!.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func startOpacityAnimation() {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.3
        opacityAnimation.duration = 0.8
        opacityAnimation.autoreverses = true
        opacityAnimation.repeatCount = .infinity
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        imageView?.layer.add(opacityAnimation, forKey: "opacityAnimation")
    }
}

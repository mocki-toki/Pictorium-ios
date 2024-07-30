//
//  TabBarViewController.swift
//  Pictorium
//
//  Created by Simon Butenko on 22.07.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()

        let imagesListViewController =
            ImagesListViewControllerFactory.makeController()
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage.mainNavigatorBarActive,
            selectedImage: nil
        )

        let profileViewController = ProfileViewControllerFactory.makeController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage.profileNavigatorBarItem,
            selectedImage: nil
        )

        self.viewControllers = [imagesListViewController, profileViewController]
    }
}

//
//  MainTabBarController.swift
//  MyMap
//
//  Created by 이지현 on 2023/11/19.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        viewControllers = [
            setupVC(viewController: MapViewController(), title: "Map", image: UIImage(systemName: "map.fill")),
            setupVC(viewController: WishlistViewController(), title: "Wishlist", image: UIImage(systemName: "star.fill")),
            setupVC(viewController: VisitedViewController(), title: "Visited", image: UIImage(systemName: "checkmark.circle.fill"))
        ]
    }
    
    private func setupVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return UINavigationController(rootViewController: viewController)
    }

}


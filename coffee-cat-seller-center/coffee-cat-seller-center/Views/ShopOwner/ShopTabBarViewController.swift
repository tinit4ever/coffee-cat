//
//  ShopTabBarViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 27/02/2024.
//

import UIKit
import SwiftUI

class ShopTabBarViewController: UITabBarController {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTabBarHeight()
        customizeTabBarAppearance()
    }
    
    func adjustTabBarHeight() {
        tabBar.tintColor = .customBlack
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.backgroundColor = .systemBackground
        tabBar.frame.size.height = heightScaler(110)
        tabBar.frame.origin.y = view.frame.height - heightScaler(110)
        
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.cornerRadius = sizeScaler(30)
        tabBar.layer.masksToBounds = true
    }
    
    // MARK: - Tab Setup
    private func setupTabs() {
        let staffAccount = self.createNav(with: "Staffs", and: UIImage(systemName: "person"), viewController: StaffAccountViewController())
        let place = self.createNav(with: "Place", and: UIImage(systemName: "table.furniture"), viewController: PlaceViewController())
        let menu = self.createNav(with: "Menu", and: UIImage(systemName: "menucard"), viewController: MenuViewController())
        let cat = self.createNav(with: "Cat", and: UIImage(systemName: "cat"), viewController: CatViewController())
        let shopManager = self.createNav(with: "Manager", and: UIImage(systemName: "storefront"), viewController: ShopManagerViewController())
        self.setViewControllers([staffAccount, place, menu, cat, shopManager], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.title = nil
        nav.tabBarItem.image = image
        nav.tabBarItem.selectedImage = image
        nav.tabBarItem.title = title
        nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: sizeScaler(18))], for: .normal)
        nav.isNavigationBarHidden = true
        return nav
    }
    
    private func customizeTabBarAppearance() {
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -heightScaler(5))
        tabBar.layer.shadowRadius = sizeScaler(4)
        tabBar.layer.masksToBounds = false
    }
}

// -MARK: Preview
struct ShopTabBarViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let shopTabBarViewController = ShopTabBarViewController()
            return shopTabBarViewController
        }
    }
}

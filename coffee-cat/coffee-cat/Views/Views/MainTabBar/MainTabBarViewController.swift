//
//  MainTabBarViewController.swift
//  coffee-cat
//
//  Created by Tin on 31/01/2024.
//

import UIKit
import SwiftUI

class MainTabBarViewController: UITabBarController {
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
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.backgroundColor = .white
        tabBar.frame.size.height = heightScaler(120)
        tabBar.frame.origin.y = view.frame.height - heightScaler(120)
        
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.cornerRadius = sizeScaler(30)
        tabBar.layer.masksToBounds = true
    }
    
    // MARK: - Tab Setup
    private func setupTabs() {
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house.fill"), viewController: HomeViewController())
        let booking = self.createNav(with: "Booking", and: UIImage(systemName: "calendar.badge.plus"), viewController: BookingViewController())
        let store = self.createNav(with: "Store", and: UIImage(systemName: "storefront.fill"), viewController: StoreViewController())
        let voucher = self.createNav(with: "Voucher", and: UIImage(systemName: "gift.fill"), viewController: VoucherViewController())
        let account = self.createNav(with: "Account", and: UIImage(systemName: "person.fill"), viewController: AccountViewController())
        
        self.setViewControllers([home, booking, store, voucher, account], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.title = nil
        nav.tabBarItem.image = image
        nav.tabBarItem.selectedImage = image
        nav.tabBarItem.title = title
        nav.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: sizeScaler(18))], for: .normal)
        nav.viewControllers.first?.navigationItem.title = title + " Controller"
        nav.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Button", style: .plain, target: nil, action: nil)
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
struct MainViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let mainViewController = MainTabBarViewController()
            return mainViewController
        }
    }
}
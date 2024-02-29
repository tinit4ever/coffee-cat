//
//  TransitionViewController.swift
//  coffee-cat
//
//  Created by Tin on 29/02/2024.
//

import UIKit

class TransitionViewController: UIViewController {
    
    var isFirstLoad: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.isFirstLoad = true
        
        let backImage = UIImage(systemName: "chevron.backward.circle.fill")?
            .withTintColor(.backButton, renderingMode: .alwaysOriginal)
        
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .backButton
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFirstLoad {
            self.navigationController?.pushViewController(SignInViewController(), animated: true)
        } else {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = windowScene.windows.first
                window?.rootViewController = MainTabBarViewController()
                window?.makeKeyAndVisible()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.isFirstLoad = false
    }
}

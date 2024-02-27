//
//  ProfileViewController.swift
//  coffee-cat
//
//  Created by Tin on 01/02/2024.
//

import UIKit
import SwiftUI

class ProfileViewController: UIViewController {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray5
    }
    
    private func configNavigation() {
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        self.navigationItem.backBarButtonItem?.tintColor = .backButton
        self.navigationItem.title = "A"
    }
    
    private func setupUI() {
        configAppearance()
        configNavigation()
    }
}

// -MARK: Preview
struct ProfileViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let profileViewController = ProfileViewController()
            return profileViewController
        }
    }
}

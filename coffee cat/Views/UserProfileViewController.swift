//
//  UserProfileViewController.swift
//  coffee cat
//
//  Created by Tin on 19/01/2024.
//

import UIKit
import SwiftUI

class UserProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .systemMint
    }
}

// -MARK: Preview
//struct UserProfileViewControllerPreview: PreviewProvider {
//    static var previews: some View {
//        VCPreview {
//            let userProfileViewController = UserProfileViewController()
//            userProfileViewController.navigationItem.title = "User Profile"
//            return userProfileViewController
//        }
//    }
//}

struct UserProfileViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let userProfileViewController = UserProfileViewController()
            return userProfileViewController
        }
    }
}

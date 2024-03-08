//
//  ProfileViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 02/03/2024.
//

import UIKit
import SwiftUI

class ProfileViewController: UIViewController, ProfileFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: ProfileViewModelProtocol = ProfileViewModel()
    
    // -MARK: Create UI Components
    lazy var animationView = makeLottieAnimationView(animationName: "profile")
    
    lazy var profileStack = makeVerticalStackView()
    
    lazy var emailStack = makeHorizontalStackView()
    lazy var emailTitle = makeLabel()
    lazy var emailLabel = makeLabel()
    
    lazy var usernameStack = makeHorizontalStackView()
    lazy var usernameTitle = makeLabel()
    lazy var usernameLabel = makeLabel()
    
    lazy var phoneStack = makeHorizontalStackView()
    lazy var phoneTitle = makeLabel()
    lazy var phoneLabel = makeLabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray5
    }
    
    private func configNavigation() {
        self.navigationItem.title = "Profile"
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelButtonTapped))
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutButtonTapped))
        logoutButton.tintColor = .systemPurple
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    private func setupUI() {
        configAppearance()
        configNavigation()
        
        view.addSubview(animationView)
        animationView.play()
        configAnimationView()
        
        view.addSubview(profileStack)
        configProfileStack()
    }
    
    private func configAnimationView() {
        animationView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            animationView.widthAnchor.constraint(equalToConstant: widthScaler(800)),
            animationView.heightAnchor.constraint(equalToConstant: sizeScaler(450)),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configProfileStack() {
        profileStack.spacing = heightScaler(30)
        NSLayoutConstraint.activate([
            profileStack.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: heightScaler(40)),
            profileStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(50)),
            profileStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(50)),
            profileStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        profileStack.addArrangedSubview(emailStack)
        emailStack.alignment = .center
        emailStack.spacing = widthScaler(80)
        emailStack.addArrangedSubview(emailTitle)
        emailStack.heightAnchor.constraint(equalToConstant: heightScaler(40)).isActive = true
        emailTitle.heightAnchor.constraint(equalToConstant: heightScaler(40)).isActive = true
        
        emailTitle.widthAnchor.constraint(equalToConstant: widthScaler(320)).isActive = true
        emailStack.addArrangedSubview(emailLabel)
        
        profileStack.addArrangedSubview(usernameStack)
        usernameStack.alignment = .center
        usernameStack.spacing = widthScaler(80)
        usernameStack.addArrangedSubview(usernameTitle)
        usernameStack.heightAnchor.constraint(equalToConstant: heightScaler(40)).isActive = true
        usernameTitle.heightAnchor.constraint(equalToConstant: heightScaler(40)).isActive = true
        
        usernameTitle.widthAnchor.constraint(equalToConstant: widthScaler(320)).isActive = true
        usernameStack.addArrangedSubview(usernameLabel)
        
        profileStack.addArrangedSubview(phoneStack)
        phoneStack.alignment = .center
        phoneStack.spacing = widthScaler(80)
        phoneStack.addArrangedSubview(phoneTitle)
        phoneStack.heightAnchor.constraint(equalToConstant: heightScaler(40)).isActive = true
        phoneTitle.heightAnchor.constraint(equalToConstant: heightScaler(40)).isActive = true
        
        phoneTitle.widthAnchor.constraint(equalToConstant: widthScaler(320)).isActive = true
        phoneStack.addArrangedSubview(phoneLabel)
    }
    
    // -MARK: Setup Data
    private func setupData() {
        guard let userInfor = UserSessionManager.shared.getUserProfile() else {
            return
        }

        let email = userInfor.email
        let username = userInfor.name
        let phone = userInfor.phone
        
        emailTitle.setupTitle(text: "Email", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        emailTitle.setBoldText()
        emailTitle.backgroundColor = .systemPurple
        emailTitle.layer.cornerRadius = sizeScaler(10)
        emailTitle.layer.masksToBounds = true
        
        emailLabel.setupTitle(text: email, fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        emailLabel.textAlignment = .left
        
        usernameTitle.setupTitle(text: "Username", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        usernameTitle.setBoldText()
        usernameTitle.backgroundColor = .systemPurple
        usernameTitle.layer.cornerRadius = sizeScaler(10)
        usernameTitle.layer.masksToBounds = true
        
        usernameLabel.setupTitle(text: username ?? "Unknown", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        usernameLabel.textAlignment = .left
        
        phoneTitle.setupTitle(text: "Phone", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        phoneTitle.setBoldText()
        phoneTitle.backgroundColor = .systemPurple
        phoneTitle.layer.cornerRadius = sizeScaler(10)
        phoneTitle.layer.masksToBounds = true
        
        phoneLabel.setupTitle(text: phone ?? "Unknown", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        phoneLabel.textAlignment = .left
    }
    
    // -MARK: Catch Action
    @objc
    private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func logoutButtonTapped() {
        self.viewModel.logout(accessToken: UserSessionManager.shared.getAccessToken() ?? "") { result in
            switch result {
            case .success(let authenticationResponse):
                UserSessionManager.shared.clearSession()
                self.displaylogoutSuccess(authenticationResponse.message ?? "Success")
            case .failure(let error):
                self.displaylogoutError("Something when wrong")
                print(error.localizedDescription)
            }
        }
    }
    
    // -MARK: Utilities
    private func displaylogoutError(_ message: String) {
        let alertController = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func displaylogoutSuccess(_ title: String) {
        let alertController = UIAlertController(title: title, message: "See you!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.returnSignIn()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func returnSignIn() {
        let signInViewController = SignInViewController()
        let navigationController = UINavigationController(rootViewController: signInViewController)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = windowScene.windows.first
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
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

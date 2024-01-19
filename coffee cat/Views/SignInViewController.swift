//
//  SignInViewController.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit
import SwiftUI

class SignInViewController: UIViewController, UIFactory {
    
    // -MARK: Create UI Components
    lazy var welcomeLabel: UILabel = makeLabel()
    
    lazy var coffeeCatImageView: UIImageView = makeSquareImageView(imageName: ImageNames.coffeeCat, size: 260)
    
    lazy var emailTextFieldContainer: UIView = makeRoundedTextFieldContainer()
    lazy var emailTextField: UITextField = makeTextField(placeholder: SignInScreenText.emailTextFieldPlaceholder)
    
    lazy var passwordTextFieldContainer: UIView = makeRoundedTextFieldContainer()
    lazy var passwordTextField: UITextField = makeTextField(placeholder: SignInScreenText.passwordTextFieldPlaceholder)
    
    lazy var signInButton: UIButton = makeButton()
    
    lazy var forgetPasswordButton: UIButton = makeButton()
    
    lazy var signInWithGoogleButton: UIButton = makeButton()
    
    lazy var alternativeStackView: UIStackView = makeHorizontalStackView()
    lazy var alternativeLabel: UILabel = makeLabel()
    lazy var alternativeButton: UIButton = makeButton()
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
    
    // -MARK: Override
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configAppearance()
        }
    }
    
    
    // -MARK: SetupUI
    
    func setupUI() {
        configAppearance()
        
        configNavigation()
        
        view.addSubview(welcomeLabel)
        configWelcomeLabel()
        
        view.addSubview(coffeeCatImageView)
        configCoffeeCatImageView()
        
        view.addSubview(emailTextFieldContainer)
        configEmailTextFieldContainer()
        
        view.addSubview(passwordTextFieldContainer)
        configPasswordTextFieldContainer()
        
        view.addSubview(signInButton)
        configSignInButton()
        
        view.addSubview(forgetPasswordButton)
        configForgetPasswordButton()
        
        view.addSubview(signInWithGoogleButton)
        configSignInWithGoogleButton()
        
        view.addSubview(alternativeStackView)
        configAlternativeStackView()
    }
    
    func configAppearance() {
        view.backgroundColor = .systemGray5
        
        removeCircleGroupImageView()
        checkAndChangeAppearancceMode()
    }
    
    func removeCircleGroupImageView() {
        for subview in view.subviews {
            if let imageView = subview as? UIImageView,
               imageView.image == UIImage(named: ImageNames.darkCircleGroup) ||
                imageView.image == UIImage(named: ImageNames.lightCircleGroup)
            {
                imageView.removeFromSuperview()
            }
        }
    }

    
    func checkAndChangeAppearancceMode() {
        if traitCollection.userInterfaceStyle == .dark {
            let imageView = UIImageView(image: UIImage(named: ImageNames.darkCircleGroup))
            view.addSubview(imageView)
        } else {
            let imageView = UIImageView(image: UIImage(named: ImageNames.lightCircleGroup))
            view.addSubview(imageView)
        }
    }
    
    func configNavigation() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(customView: emailTextFieldContainer)
        self.navigationItem.backBarButtonItem?.tintColor = .systemBackground
    }
    
    func configWelcomeLabel() {
        welcomeLabel.setupTitle(text: SignInScreenText.welcomeLabel, fontName: FontNames.avenir, size: 29, textColor: .systemBrown)
        welcomeLabel.setBoldText()
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 5),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    func configCoffeeCatImageView() {
        NSLayoutConstraint.activate([
            coffeeCatImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            coffeeCatImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configEmailTextFieldContainer() {
        emailTextFieldContainer.addRoundedTextField(emailTextField)
        emailTextField.keyboardType = .emailAddress
        
        emailTextFieldContainer.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            emailTextFieldContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 430),
            emailTextFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailTextFieldContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configPasswordTextFieldContainer() {
        let showPasswordButton = makeButton()
        
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        showPasswordButton.setImage(UIImage(systemName: SystemImageNames.eye), for: .normal)
        
        passwordTextField.rightView = showPasswordButton
        passwordTextField.rightViewMode = .always
        
        passwordTextFieldContainer.addRoundedTextField(passwordTextField)
        passwordTextField.isSecureTextEntry = true
        
        passwordTextFieldContainer.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            passwordTextFieldContainer.topAnchor.constraint(equalTo: emailTextFieldContainer.bottomAnchor, constant: 30),
            passwordTextFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextFieldContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configSignInButton() {
        signInButton.cornerRadius(cornerRadius: 30)
        signInButton.setTitle(title: SignInScreenText.signInButtonTitle, fontName: FontNames.avenir, size: 30, color: .systemGray5)
        signInButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: passwordTextFieldContainer.bottomAnchor, constant: 40),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signInButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configForgetPasswordButton() {
        forgetPasswordButton.removeBackground()
        forgetPasswordButton.setTitle(title: SignInScreenText.forgetPasswordButtonTitle, fontName: FontNames.avenir, size: 20, color: .systemBlue)
        NSLayoutConstraint.activate([
            forgetPasswordButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            forgetPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            forgetPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            //            forgetPasswordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
    func configSignInWithGoogleButton() {
        let logoImageView: UIImageView = makeSquareImageView(imageName: ImageNames.googleLogo, size: 30)
        signInWithGoogleButton.addSubview(logoImageView)
        signInWithGoogleButton.removeBackground()
        signInWithGoogleButton.addBorder(width: 2, color: .systemGray)
        signInWithGoogleButton.cornerRadius(cornerRadius: 30)
        signInWithGoogleButton.setTitle(title: SignInScreenText.signInWithGoogleButtonTitle, fontName: FontNames.avenir, size: 20, color: .customBlack)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: signInWithGoogleButton.leadingAnchor, constant: 30),
            logoImageView.centerYAnchor.constraint(equalTo: signInWithGoogleButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            signInWithGoogleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signInWithGoogleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signInWithGoogleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            signInWithGoogleButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configAlternativeStackView() {
        alternativeStackView.addArrangedSubview(alternativeLabel)
        alternativeLabel.setupTitle(text: SignInScreenText.alternativeLabel, fontName: FontNames.avenir, size: 20, textColor: .customBlack)
        alternativeLabel.numberOfLines = 1
        
        alternativeStackView.addArrangedSubview(alternativeButton)
        alternativeButton.removeBackground()
        alternativeButton.setTitle(title: SignInScreenText.alternativeButtonTitle, fontName: FontNames.avenir, size: 20, color: .systemBlue)
        
        NSLayoutConstraint.activate([
            alternativeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            alternativeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),
            alternativeStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    // -MARK: Setup Action
    func setupAction() {
        alternativeButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    // -MARK: Catch Action
    @objc
    func signUpButtonTapped() {
        let signUpViewController = SignUpViewController()
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    @objc
    func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let eyeSymbol = passwordTextField.isSecureTextEntry ? SystemImageNames.eye : SystemImageNames.eyeSlash
        if let showPasswordButton = passwordTextField.rightView as? UIButton {
            showPasswordButton.setImage(UIImage(systemName: eyeSymbol), for: .normal)
        }
    }
}

// -MARK: Preview
struct SignInViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let signInViewControllerPreview = SignInViewController()
            return signInViewControllerPreview
        }
    }
}

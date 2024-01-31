//
//  SignInViewController.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit
import SwiftUI

class SignInViewController: UIViewController, UIFactory {
    let sizeScaler = UIScreen.scalableSize
    
    // -MARK: Create UI Components
    lazy var welcomeLabel: UILabel = makeLabel()
    
    lazy var animationView = makeLottieAnimationView(animationName: "cat-coffee")
    
    lazy var emailTextFieldContainer: UIView = makeRoundedContainer()
    lazy var emailTextField: UITextField = makeTextField(placeholder: SignInScreenText.emailTextFieldPlaceholder)
    
    lazy var passwordTextFieldContainer: UIView = makeRoundedContainer()
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
        
        view.addSubview(animationView)
        animationView.play()
        configAnimationView()
        
        view.addSubview(emailTextFieldContainer)
        configEmailTextFieldContainer()
        
        view.addSubview(passwordTextFieldContainer)
        configPasswordTextFieldContainer()
        
        view.addSubview(signInButton)
        configSignInButton()
        
        view.addSubview(forgetPasswordButton)
        configForgetPasswordButton()
        
        view.addSubview(signInWithGoogleButton)
        view.addSubview(alternativeStackView)
        configSignInWithGoogleButton()
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .backButton
    }
    
    func configWelcomeLabel() {
        welcomeLabel.setupTitle(text: SignInScreenText.welcomeLabel, fontName: FontNames.avenir, size: 26, textColor: .systemBrown)
        welcomeLabel.setBoldText()
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.screenHeightUnit * 150),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 30),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 30)),
        ])
    }
    
    func configAnimationView() {
        animationView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            animationView.widthAnchor.constraint(equalToConstant: sizeScaler(300)),
            animationView.heightAnchor.constraint(equalToConstant: sizeScaler(250)),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configEmailTextFieldContainer() {
        emailTextFieldContainer.addRoundedTextField(emailTextField)
        emailTextField.keyboardType = .emailAddress
        
        emailTextFieldContainer.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            emailTextFieldContainer.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: UIScreen.screenHeightUnit * 30),
            emailTextFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 60),
            emailTextFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 60)),
            emailTextFieldContainer.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 60)
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
            passwordTextFieldContainer.topAnchor.constraint(equalTo: emailTextFieldContainer.bottomAnchor, constant: UIScreen.screenHeightUnit * 30),
            passwordTextFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 60),
            passwordTextFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 60)),
            passwordTextFieldContainer.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 60)
        ])
    }
    
    func configSignInButton() {
        signInButton.cornerRadius(cornerRadius: UIScreen.screenHeightUnit * 30)
        signInButton.setTitle(title: SignInScreenText.signInButtonTitle, fontName: FontNames.avenir, size: sizeScaler(40), color: .systemGray5)
        signInButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: passwordTextFieldContainer.bottomAnchor, constant: UIScreen.screenHeightUnit * 40),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 60),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 60)),
            signInButton.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 60)
        ])
    }
    
    func configForgetPasswordButton() {
        forgetPasswordButton.removeBackground()
        forgetPasswordButton.setTitle(title: SignInScreenText.forgetPasswordButtonTitle, fontName: FontNames.avenir, size: sizeScaler(25), color: .systemBlue)
        NSLayoutConstraint.activate([
            forgetPasswordButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: UIScreen.screenHeightUnit * 30),
            forgetPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 30),
            forgetPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 30)),
            forgetPasswordButton.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 30)
        ])
    }
    
    func configSignInWithGoogleButton() {
        let logoImageView: UIImageView = makeSquareImageView(imageName: ImageNames.googleLogo, size: sizeScaler(70))
        signInWithGoogleButton.addSubview(logoImageView)
        signInWithGoogleButton.removeBackground()
        signInWithGoogleButton.addBorder(width: 2, color: .systemGray)
        signInWithGoogleButton.cornerRadius(cornerRadius: UIScreen.screenHeightUnit * 30)
        signInWithGoogleButton.setTitle(title: SignInScreenText.signInWithGoogleButtonTitle, fontName: FontNames.avenir, size: sizeScaler(30), color: .customBlack)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: signInWithGoogleButton.leadingAnchor, constant: UIScreen.screenWidthtUnit * 30),
            logoImageView.centerYAnchor.constraint(equalTo: signInWithGoogleButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            signInWithGoogleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 60),
            signInWithGoogleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 60)),
            signInWithGoogleButton.bottomAnchor.constraint(equalTo: alternativeStackView.topAnchor, constant: -(UIScreen.screenHeightUnit * 20)),
            signInWithGoogleButton.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 60)
        ])
    }
    
    func configAlternativeStackView() {
        alternativeStackView.addArrangedSubview(alternativeLabel)
        alternativeStackView.distribution = .fillProportionally
        alternativeStackView.alignment = .center
        
        alternativeLabel.setupTitle(text: SignInScreenText.alternativeLabel, fontName: FontNames.avenir, size: sizeScaler(28), textColor: .customBlack)
        alternativeLabel.numberOfLines = 1
        alternativeLabel.adjustsFontSizeToFitWidth = true
        
        alternativeStackView.addArrangedSubview(alternativeButton)
        alternativeButton.removeBackground()
        alternativeButton.setTitle(title: SignInScreenText.alternativeButtonTitle, fontName: FontNames.avenir, size: sizeScaler(28), color: .systemBlue)
        
        NSLayoutConstraint.activate([
            alternativeStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(UIScreen.screenHeightUnit * 20)),
            alternativeStackView.widthAnchor.constraint(equalToConstant: UIScreen.screenWidthtUnit * 700),
            alternativeStackView.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 30),
            alternativeStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // -MARK: Supporting
    
    private func pushViewController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToHome() {
        let homeViewController = HomeViewController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = windowScene.windows.first
            window?.rootViewController = homeViewController
            window?.makeKeyAndVisible()
        }
    }
    
    // -MARK: Setup Action
    private func setupAction() {
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        alternativeButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    // -MARK: Catch Action
    @objc 
    private func signInButtonTapped() {
        pushToHome()
    }
    
    @objc
    private func signUpButtonTapped() {
        pushViewController(viewController: SignUpViewController())
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
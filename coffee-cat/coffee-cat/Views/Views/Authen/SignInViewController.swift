//
//  SignInViewController.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit
import SwiftUI
import Lottie

class SignInViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: SignInViewModelProtocol = SignInViewModel()
    
    // -MARK: Create UI Components
    lazy var welcomeLabel: UILabel = makeLabel()
    
    lazy var animationView = makeLottieAnimationView(animationName: "cat-coffee")
    
    lazy var emailTextFieldContainer: UIView = makeRoundedContainer()
    lazy var emailTextField: UITextField = makeTextField(placeholder: SignInScreenText.emailTextFieldPlaceholder)
    
    lazy var passwordTextFieldContainer: UIView = makeRoundedContainer()
    lazy var passwordTextField: UITextField = makeTextField(placeholder: SignInScreenText.passwordTextFieldPlaceholder)
    lazy var showPasswordButton = makeButton()
    
    lazy var signInButton: UIButton = makeButton()
    
    lazy var forgetPasswordButton: UIButton = makeButton()
    
    lazy var signInWithGoogleButton: UIButton = makeButton()
    
    lazy var alternativeStackView: UIStackView = makeHorizontalStackView()
    lazy var alternativeLabel: UILabel = makeLabel()
    lazy var alternativeButton: UIButton = makeButton()
    
    lazy var loadingAnimationView = makeLottieAnimationView(animationName: "loading")
    
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
    
    private func setupUI() {
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
        
        view.addSubview(loadingAnimationView)
        configLoadingView()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray5
        
        removeCircleGroupImageView()
        checkAndChangeAppearancceMode()
    }
    
    private func removeCircleGroupImageView() {
        for subview in view.subviews {
            if let imageView = subview as? UIImageView,
               let imageName = imageView.image?.accessibilityIdentifier,
               (imageName == ImageNames.darkCircleGroup || imageName == ImageNames.lightCircleGroup)
            {
                imageView.removeFromSuperview()
            }
        }
    }
    
    private func checkAndChangeAppearancceMode() {
        if traitCollection.userInterfaceStyle == .dark {
            let image = UIImage(named: ImageNames.darkCircleGroup)
            image?.accessibilityIdentifier = ImageNames.darkCircleGroup
            
            let resizedImage = image?.resized(to: CGSize(width: widthScaler(700), height: heightScaler(200)))
            
            let imageView = UIImageView(image: resizedImage)
            imageView.image?.accessibilityIdentifier = ImageNames.darkCircleGroup
            
            view.addSubview(imageView)
            
        } else {
            let image = UIImage(named: ImageNames.darkCircleGroup)
            image?.accessibilityIdentifier = ImageNames.darkCircleGroup
            
            let resizedImage = image?.resized(to: CGSize(width: widthScaler(700), height: heightScaler(200)))
            
            let imageView = UIImageView(image: resizedImage)
            imageView.image?.accessibilityIdentifier = ImageNames.darkCircleGroup
            
            view.addSubview(imageView)
            
        }
    }
    
    private func configNavigation() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .backButton
    }
    
    private func configWelcomeLabel() {
        welcomeLabel.setupTitle(text: SignInScreenText.welcomeLabel, fontName: FontNames.avenir, size: 26, textColor: .systemBrown)
        welcomeLabel.setBoldText()
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.screenHeightUnit * 160),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 30),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 30)),
        ])
    }
    
    private func configAnimationView() {
        animationView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            animationView.widthAnchor.constraint(equalToConstant: sizeScaler(300)),
            animationView.heightAnchor.constraint(equalToConstant: sizeScaler(250)),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configEmailTextFieldContainer() {
        emailTextFieldContainer.addRoundedTextField(emailTextField)
        emailTextField.keyboardType = .emailAddress
        
        emailTextFieldContainer.backgroundColor = .textFieldContainer
        NSLayoutConstraint.activate([
            emailTextFieldContainer.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: UIScreen.screenHeightUnit * 30),
            emailTextFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 60),
            emailTextFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 60)),
            emailTextFieldContainer.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 60)
        ])
    }
    
    private func configPasswordTextFieldContainer() {
        showPasswordButton.showPasswordButton()
        
        passwordTextField.showPasswordButton(showPasswordButton: showPasswordButton)
        
        passwordTextFieldContainer.addRoundedTextField(passwordTextField)
        passwordTextField.isSecureTextEntry = true
        
        passwordTextFieldContainer.backgroundColor = .textFieldContainer
        NSLayoutConstraint.activate([
            passwordTextFieldContainer.topAnchor.constraint(equalTo: emailTextFieldContainer.bottomAnchor, constant: UIScreen.screenHeightUnit * 30),
            passwordTextFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 60),
            passwordTextFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 60)),
            passwordTextFieldContainer.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 60)
        ])
    }
    
    private func configSignInButton() {
        signInButton.cornerRadius(cornerRadius: UIScreen.screenHeightUnit * 30)
        signInButton.setTitle(title: SignInScreenText.signInButtonTitle, fontName: FontNames.avenir, size: sizeScaler(40), color: .systemGray5)
        signInButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: passwordTextFieldContainer.bottomAnchor, constant: UIScreen.screenHeightUnit * 80),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 60),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 60)),
            signInButton.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 60)
        ])
    }
    
    private func configForgetPasswordButton() {
        forgetPasswordButton.removeBackground()
        forgetPasswordButton.setTitle(title: SignInScreenText.forgetPasswordButtonTitle, fontName: FontNames.avenir, size: sizeScaler(25), color: .systemBlue)
        NSLayoutConstraint.activate([
            forgetPasswordButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: UIScreen.screenHeightUnit * 30),
            forgetPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 30),
            forgetPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 30)),
            forgetPasswordButton.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 30)
        ])
    }
    
    private func configSignInWithGoogleButton() {
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
    
    private func configAlternativeStackView() {
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
    
    private func configLoadingView() {
        loadingAnimationView.isHidden = true
        NSLayoutConstraint.activate([
            loadingAnimationView.widthAnchor.constraint(equalToConstant: sizeScaler(300)),
            loadingAnimationView.heightAnchor.constraint(equalToConstant: sizeScaler(300)),
            loadingAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // -MARK: Supporting
    
    private func pushViewController(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func pushToHome() {
        let homeViewController = MainTabBarViewController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = windowScene.windows.first
            window?.rootViewController = homeViewController
            window?.makeKeyAndVisible()
        }
    }
    
    // -MARK: Setup Action
    private func setupAction() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        alternativeButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    // -MARK: Catch Action
    @objc
    private func signInButtonTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        self.viewModel.signIn(email, password) { [weak self] result in
            self?.showLoadingView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                switch result {
                case .success(let authenticationResponse):
                    DispatchQueue.main.async {
                        if authenticationResponse.status ?? false {
                            self?.hiddenLoadingView()
                            UserSessionManager.shared.saveAuthenticationResponse(authenticationResponse)
                            self?.pushToHome()
                        } else {
                            self?.displayLoginError(authenticationResponse.message ?? "Unknown error")
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                        self?.displayLoginError("Could not connect to the server\n Please check your internet connection")
                    }
                }
            }
        }
    }
    
    @objc
    private func signUpButtonTapped() {
        pushViewController(viewController: SignUpViewController())
    }
    
    @objc
    private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let eyeSymbol = passwordTextField.isSecureTextEntry ? SystemImageNames.eyeSlash : SystemImageNames.eye
        if let showPasswordButton = passwordTextField.rightView as? UIButton {
            showPasswordButton.setImage(UIImage(systemName: eyeSymbol), for: .normal)
        }
    }
    
    // -MARK: Utilities
    private func displayLoginError(_ message: String) {
        hiddenLoadingView()
        let alertController = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showLoadingView() {
        self.loadingAnimationView.isHidden = false
        self.loadingAnimationView.play()
        self.view.isUserInteractionEnabled = false
    }
    
    private func hiddenLoadingView() {
        self.loadingAnimationView.isHidden = true
        self.loadingAnimationView.stop()
        self.view.isUserInteractionEnabled = true
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
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

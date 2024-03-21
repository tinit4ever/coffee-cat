//
//  SignInViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 26/02/2024.
//

import UIKit
import SwiftUI
import Lottie

class SignInViewController: UIViewController, SignInFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: SignInViewModelProtocol = SignInViewModel()
    
    // -MARK: Create UI Components
    lazy var welcomeLabel: UILabel = makeLabel()
    
    lazy var animationView = makeLottieAnimationView(animationName: "administrator")
    
    lazy var emailTextFieldContainer: UIView = makeRoundedContainer()
    lazy var emailTextField: UITextField = makeTextField(placeholder: "Enter email")
    
    lazy var passwordTextFieldContainer: UIView = makeRoundedContainer()
    lazy var passwordTextField: UITextField = makeTextField(placeholder: "Enter password")
    lazy var showPasswordButton = makeButton()
    
    lazy var signInButton: UIButton = makeButton()
    
    lazy var loadingAnimationView = makeLottieAnimationView(animationName: "loading")
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        
    }
    
    // -MARK: SetupUI
    
    private func setupUI() {
        configAppearance()
        
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
        
        view.addSubview(loadingAnimationView)
        configLoadingView()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemBackground
    }
    
    private func configWelcomeLabel() {
        welcomeLabel.setupTitle(text: "Welcome", fontName: FontNames.avenir, size: sizeScaler(80), textColor: .systemBrown)
        welcomeLabel.setBoldText()
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.screenHeightUnit * 100),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 30),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 30)),
        ])
    }
    
    private func configAnimationView() {
        animationView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            animationView.heightAnchor.constraint(equalToConstant: heightScaler(300)),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configEmailTextFieldContainer() {
        emailTextFieldContainer.addRoundedTextField(emailTextField)
        emailTextField.keyboardType = .emailAddress
        
        emailTextFieldContainer.backgroundColor = .systemGray6
        NSLayoutConstraint.activate([
            emailTextFieldContainer.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: heightScaler(80)),
            emailTextFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            emailTextFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
            emailTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    private func configPasswordTextFieldContainer() {
        showPasswordButton.showPasswordButton()
        
        passwordTextField.showPasswordButton(showPasswordButton: showPasswordButton)
        
        passwordTextFieldContainer.addRoundedTextField(passwordTextField)
        passwordTextField.isSecureTextEntry = true
        
        passwordTextFieldContainer.backgroundColor = .systemGray6
        NSLayoutConstraint.activate([
            passwordTextFieldContainer.topAnchor.constraint(equalTo: emailTextFieldContainer.bottomAnchor, constant: UIScreen.screenHeightUnit * 40),
            passwordTextFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            passwordTextFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
            passwordTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    private func configSignInButton() {
        signInButton.cornerRadius(cornerRadius: UIScreen.screenHeightUnit * 30)
        signInButton.setTitle(title: "Sign In", fontName: FontNames.avenir, size: sizeScaler(40), color: .systemGray5)
        signInButton.backgroundColor = .systemPurple.withAlphaComponent(0.7)
        
        NSLayoutConstraint.activate([
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
            signInButton.heightAnchor.constraint(equalToConstant: heightScaler(60)),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -heightScaler(20))
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
    
    private func pushToHome(homeViewController: UIViewController) {
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
    }
    
    // -MARK: Catch Action
    @objc
    private func signInButtonTapped() {
        self.showLoadingView()
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        self.viewModel.signIn(email, password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let authenticationResponse):
                    DispatchQueue.main.async {
                        if authenticationResponse.status ?? false {
                            self?.handleLogin(authenticationResponse: authenticationResponse)
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
    
    private func handleLogin(authenticationResponse: AuthenticationResponse) {
        if let role = authenticationResponse.accountResponse?.role,
           let accountStatus = authenticationResponse.accountResponse?.status {
            guard role != .customer else {
                self.handleLoginUnavailable("You don't have permission")
                return
            }
            
            switch accountStatus {
            case .active:
                self.handleLoginAvailable(authenticationResponse: authenticationResponse, role: role)
            case .inactive:
                self.handleLoginUnavailable("You have been banned")
            }
        }
    }
    
    private func handleLoginAvailable(authenticationResponse: AuthenticationResponse, role: Role) {
        UserSessionManager.shared.saveAuthenticationResponse(authenticationResponse)
        self.hiddenLoadingView()
        switch role {
        case .admin:
            self.pushToHome(homeViewController: AdminViewController())
        case .shopOwner:
            self.pushToHome(homeViewController: ShopTabBarViewController())
        case .staff:
            let viewController = BookingManagerViewController()
            self.pushToHome(homeViewController: viewController)
        case .customer:
            break
        }
    }
    
    private func handleLoginUnavailable(_ message: String) {
        self.displayLoginError(message)
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

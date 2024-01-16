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
    
    lazy var emailTextFieldContainer: UIView = makeRoundedTextFieldContainer()
    lazy var emailTextField: UITextField = makeTextField(placeholder: SignInScreenText.emailTextFieldPlaceholder)
    
    lazy var passwordTextFieldContainer: UIView = makeRoundedTextFieldContainer()
    lazy var passwordTextField: UITextField = makeTextField(placeholder: SignInScreenText.passwordTextFieldPlaceholder)
    
    lazy var forgetPasswordButton: UIButton = makeButton()
    
    lazy var signInButton: UIButton = makeButton()
    
    lazy var alternativeStackView: UIStackView = makeHorizontalStackView()
    lazy var alternativeLabel: UILabel = makeLabel()
    lazy var alternativeButton: UIButton = makeButton()
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
    
    // -MARK: SetupUI
    
    func setupUI() {
        configBackground()
        
        view.addSubview(welcomeLabel)
        configWelcomeLabel()
        
        view.addSubview(emailTextFieldContainer)
        configEmailTextFieldContainer()
        
        view.addSubview(passwordTextFieldContainer)
        configPasswordTextFieldContainer()
        
        view.addSubview(forgetPasswordButton)
        configForgetPasswordButton()
        
        view.addSubview(signInButton)
        configSignInButton()
        
        view.addSubview(alternativeStackView)
        configAlternativeStackView()
    }
    
    func configBackground() {
        let backgroundImage = UIImageView(image: UIImage(named: ImageNames.signinBackground))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.frame = view.bounds
        view.insertSubview(backgroundImage, at: 0)
    }
    
    func configWelcomeLabel() {
        welcomeLabel.setupTitle(text: "Welcome Back!", fontName: FontNames.avenir, size: 29, textColor: .black)
        welcomeLabel.setBoldText()
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 5),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    func configEmailTextFieldContainer() {
        emailTextFieldContainer.addRoundedTextField(emailTextField)
        emailTextFieldContainer.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            emailTextFieldContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 2),
            emailTextFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailTextFieldContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configPasswordTextFieldContainer() {
        passwordTextFieldContainer.addRoundedTextField(passwordTextField)
        passwordTextFieldContainer.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            passwordTextFieldContainer.topAnchor.constraint(equalTo: emailTextFieldContainer.bottomAnchor, constant: 30),
            passwordTextFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextFieldContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configForgetPasswordButton() {
        forgetPasswordButton.makeNoBorderButton()
        forgetPasswordButton.makeTitle(title: "Forget Password?", fontName: FontNames.avenir, size: 20, color: .systemBlue)
        
        NSLayoutConstraint.activate([
            forgetPasswordButton.topAnchor.constraint(equalTo: passwordTextFieldContainer.bottomAnchor, constant: 40),
            forgetPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            forgetPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    func configSignInButton() {
        signInButton.makeCornerRadius(cornerRadius: 20)
        signInButton.makeTitle(title: SignInScreenText.signInButtonTitle, fontName: FontNames.avenir, size: 30, color: .white)
        signInButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            signInButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func configAlternativeStackView() {
        alternativeStackView.addArrangedSubview(alternativeLabel)
        alternativeLabel.setupTitle(text: "Dont's have an account?", fontName: FontNames.avenir, size: 20, textColor: .black)
        alternativeLabel.numberOfLines = 1
        
        alternativeStackView.addArrangedSubview(alternativeButton)
        alternativeButton.makeNoBorderButton()
        alternativeButton.makeTitle(title: "Sign Up", fontName: FontNames.avenir, size: 20, color: .systemBlue)
        
        NSLayoutConstraint.activate([
            alternativeStackView.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            alternativeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            alternativeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55)
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


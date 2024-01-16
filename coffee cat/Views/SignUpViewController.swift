//
//  SignUpViewController.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit
import SwiftUI

class SignUpViewController: UIViewController, UIFactory {
    
    // -MARK: Create UI Components
    lazy var welcomeLabel: UILabel = makeLabel()
    
    lazy var invitationLabel: UILabel = makeLabel()
    
    lazy var fullNameTextFieldContainer: UIView = makeRoundedTextFieldContainer()
    lazy var fullNameTextField: UITextField = makeTextField(placeholder: SignUpScreenText.fullNameTextFieldPlaceholder)
    
    lazy var emailTextFieldContainer: UIView = makeRoundedTextFieldContainer()
    lazy var emailTextField: UITextField = makeTextField(placeholder: SignUpScreenText.emailTextFieldPlaceholder)
    
    lazy var passwordTextFieldContainer: UIView = makeRoundedTextFieldContainer()
    lazy var passwordTextField: UITextField = makeTextField(placeholder: SignUpScreenText.passwordTextFieldPlaceholder)
    
    lazy var confirmPasswordTextFieldContainer: UIView = makeRoundedTextFieldContainer()
    lazy var confirmPasswordTextField: UITextField = makeTextField(placeholder: SignUpScreenText.confirmPasswordTextFieldPlaceholder)
    
    lazy var registerButton: UIButton = makeButton()
    
    lazy var signInHintLabel: UILabel = makeLabel()
    
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
        
        view.addSubview(invitationLabel)
        configInvitationLabel()
        
        view.addSubview(fullNameTextFieldContainer)
        configFullNameTextFieldContainer()
        
        view.addSubview(emailTextFieldContainer)
        configEmailTextFieldContainer()
        
        view.addSubview(passwordTextFieldContainer)
        configPasswordTextFieldContainer()
        
        view.addSubview(confirmPasswordTextFieldContainer)
        configConfirmPasswordTextFieldContainer()
        
        view.addSubview(registerButton)
        configRegisterButton()
        
        view.addSubview(alternativeStackView)
        configAlternativeStackView()
        
    }
    
    func configBackground() {
        let backgroundImage = UIImageView(image: UIImage(named: ImageNames.signupBackground))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.frame = view.bounds
        view.insertSubview(backgroundImage, at: 0)
    }
    
    func configWelcomeLabel() {
        welcomeLabel.setupTitle(text: SignUpScreenText.welcome, fontName: FontNames.avenir, size: 29, textColor: .black)
        welcomeLabel.setBoldText()
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 5),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    func configInvitationLabel() {
        invitationLabel.setupTitle(text: SignUpScreenText.invitation, fontName: FontNames.avenir, size: 20, textColor: .black)
        
        NSLayoutConstraint.activate([
            invitationLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            invitationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            invitationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    func configFullNameTextFieldContainer() {
        fullNameTextFieldContainer.addRoundedTextField(fullNameTextField)
        fullNameTextFieldContainer.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            fullNameTextFieldContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 2.5),
            fullNameTextFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            fullNameTextFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            fullNameTextFieldContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configEmailTextFieldContainer() {
        emailTextFieldContainer.addRoundedTextField(emailTextField)
        emailTextFieldContainer.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            emailTextFieldContainer.topAnchor.constraint(equalTo: fullNameTextFieldContainer.bottomAnchor, constant: 30),
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
    
    func configConfirmPasswordTextFieldContainer() {
        confirmPasswordTextFieldContainer.addRoundedTextField(confirmPasswordTextField)
        confirmPasswordTextFieldContainer.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            confirmPasswordTextFieldContainer.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            confirmPasswordTextFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            confirmPasswordTextFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            confirmPasswordTextFieldContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configRegisterButton() {
        registerButton.makeCornerRadius(cornerRadius: 30)
        registerButton.makeTitle(title: SignUpScreenText.registerButtonTitle, fontName: FontNames.avenir, size: 30, color: .white)
        registerButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            registerButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func configAlternativeStackView() {
        alternativeStackView.addArrangedSubview(alternativeLabel)
        alternativeLabel.setupTitle(text: "Already have an account?", fontName: FontNames.avenir, size: 20, textColor: .black)
        alternativeLabel.numberOfLines = 1
        
        alternativeStackView.addArrangedSubview(alternativeButton)
        alternativeButton.makeNoBorderButton()
        alternativeButton.makeTitle(title: "Sign In", fontName: FontNames.avenir, size: 20, color: .systemBlue)
        
        NSLayoutConstraint.activate([
            alternativeStackView.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 10),
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
        let signInViewController = SignInViewController()
        self.navigationController?.pushViewController(signInViewController, animated: true)
    }
}

// -MARK: Preview
struct SignUpViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let signUpViewControllerPreview = SignUpViewController()
            return signUpViewControllerPreview
        }
    }
}

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
    
    lazy var emailStackView: UIStackView = makeVerticalStackView()
    lazy var emailLabel: UILabel = makeLabel()
    lazy var emailTextFieldContainer: UIView = makeRoundedTextFieldContainer()
    lazy var emailTextField: UITextField = makeTextField(placeholder: SignUpScreenText.emailTextFieldPlaceholder)
    
    lazy var nextButton: UIButton = makeButton()
    
    lazy var signUpWithGoogleButton: UIButton = makeButton()
    
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
        
        //        view.addSubview(emailTextFieldContainer)
        //        configEmailTextFieldContainer()
        view.addSubview(emailStackView)
        configEmailStackView()
        
        
        view.addSubview(nextButton)
        configNextButton()
        
        view.addSubview(signUpWithGoogleButton)
        configSignUpWithGoogleButton()
        
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
    
    func configEmailStackView() {
        emailStackView.spacing = 10
        emailStackView.contentMode = .topLeft
        emailStackView.addArrangedSubview(emailLabel)
        emailLabel.setupTitle(text: "Email address", fontName: FontNames.avenir, size: 20, textColor: .black)
        emailLabel.setBoldText()
        emailLabel.textAlignment = .left
        
        emailStackView.addArrangedSubview(emailTextFieldContainer)
        emailTextFieldContainer.addRoundedTextField(emailTextField)
        emailTextFieldContainer.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            emailStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 2.5),
            emailStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
//            emailStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
//            emailTextFieldContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 2.5),
//            emailTextFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
//            emailTextFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailTextFieldContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
//        emailLabel.backgroundColor = .red
//        emailTextFieldContainer.backgroundColor = .black
//        emailStackView.backgroundColor = .gray
    }
    
    func configNextButton() {
        nextButton.makeTitle(title: SignUpScreenText.nextButtonTitle, fontName: FontNames.avenir, size: 30, color: .white)
        nextButton.makeCornerRadius(cornerRadius: 30)
        nextButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 90),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nextButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configSignUpWithGoogleButton() {
        let logoImageView: UIImageView = makeSquareImageView(imageName: ImageNames.googleLogo, size: 30)
        signUpWithGoogleButton.addSubview(logoImageView)
        signUpWithGoogleButton.makeNoBorderButton()
        signUpWithGoogleButton.makeBorder(width: 2, color: .black)
        signUpWithGoogleButton.makeCornerRadius(cornerRadius: 30)
        signUpWithGoogleButton.makeTitle(title: SignUpScreenText.signUpWithGoogleButtonTitle, fontName: FontNames.avenir, size: 20, color: .black)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: signUpWithGoogleButton.leadingAnchor, constant: 30),
            logoImageView.centerYAnchor.constraint(equalTo: signUpWithGoogleButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            signUpWithGoogleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signUpWithGoogleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signUpWithGoogleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            signUpWithGoogleButton.heightAnchor.constraint(equalToConstant: 60)
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
            alternativeStackView.topAnchor.constraint(equalTo: signUpWithGoogleButton.bottomAnchor, constant: 10),
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

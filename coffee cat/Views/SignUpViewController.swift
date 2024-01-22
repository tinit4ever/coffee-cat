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
    
    lazy var leftDividerSubView: UIView = makeView()
    lazy var dividerLabel: UILabel = makeLabel()
    lazy var rightDividerSubView: UIView = makeView()
    
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
        
        view.addSubview(invitationLabel)
        configInvitationLabel()
        
        view.addSubview(emailStackView)
        configEmailStackView()
        
        view.addSubview(nextButton)
        configNextButton()
        
        view.addSubview(leftDividerSubView)
        configLeftDividerSubView()
        view.addSubview(dividerLabel)
        configDivideLabel()
        view.addSubview(rightDividerSubView)
        configRightDividerSubView()
        
        view.addSubview(signUpWithGoogleButton)
        configSignUpWithGoogleButton()
        
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .systemBackground
    }
    
    func configWelcomeLabel() {
        welcomeLabel.setupTitle(text: SignUpScreenText.welcome, fontName: FontNames.avenir, size: 29, textColor: .systemBrown)
        welcomeLabel.setBoldText()
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 5),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    func configInvitationLabel() {
        invitationLabel.setupTitle(text: SignUpScreenText.invitation, fontName: FontNames.avenir, size: 20, textColor: .customBlack)
        
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
        emailLabel.setupTitle(text: SignUpScreenText.emailLabel, fontName: FontNames.avenir, size: 20, textColor: .customBlack)
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
        ])
        NSLayoutConstraint.activate([
            emailTextFieldContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configNextButton() {
        nextButton.setTitle(title: SignUpScreenText.nextButtonTitle, fontName: FontNames.avenir, size: 30, color: .systemGray5)
        nextButton.cornerRadius(cornerRadius: 30)
        nextButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 70),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            nextButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configLeftDividerSubView() {
        leftDividerSubView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            leftDividerSubView.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 80),
            leftDividerSubView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            leftDividerSubView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.bounds.width / 2 + 25)),
            leftDividerSubView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    func configDivideLabel() {
        //        dividerLabel.text = SignUpScreenText.dividerLabel
        dividerLabel.setupTitle(text: SignUpScreenText.dividerLabel, fontName: FontNames.avenir, size: 20, textColor: .customBlack)
        NSLayoutConstraint.activate([
            dividerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dividerLabel.centerYAnchor.constraint(equalTo: leftDividerSubView.centerYAnchor)
        ])
    }
    
    func configRightDividerSubView() {
        rightDividerSubView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            rightDividerSubView.topAnchor.constraint(equalTo: leftDividerSubView.topAnchor),
            rightDividerSubView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width / 2 + 25),
            rightDividerSubView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            rightDividerSubView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    func configSignUpWithGoogleButton() {
        let logoImageView: UIImageView = makeSquareImageView(imageName: ImageNames.googleLogo, size: 30)
        signUpWithGoogleButton.addSubview(logoImageView)
        signUpWithGoogleButton.removeBackground()
        signUpWithGoogleButton.addBorder(width: 2, color: .systemGray)
        signUpWithGoogleButton.cornerRadius(cornerRadius: 30)
        signUpWithGoogleButton.setTitle(title: SignUpScreenText.signUpWithGoogleButtonTitle, fontName: FontNames.avenir, size: 20, color: .customBlack)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: signUpWithGoogleButton.leadingAnchor, constant: 30),
            logoImageView.centerYAnchor.constraint(equalTo: signUpWithGoogleButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            //            signUpWithGoogleButton.topAnchor.constraint(equalTo: dividerLabel.bottomAnchor, constant: 60),
            signUpWithGoogleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signUpWithGoogleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signUpWithGoogleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            signUpWithGoogleButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configAlternativeStackView() {
        alternativeStackView.addArrangedSubview(alternativeLabel)
        alternativeLabel.setupTitle(text: SignUpScreenText.alternativeLabel, fontName: FontNames.avenir, size: 20, textColor: .customBlack)
        alternativeLabel.numberOfLines = 1
        
        alternativeStackView.addArrangedSubview(alternativeButton)
        alternativeButton.removeBackground()
        alternativeButton.setTitle(title: SignUpScreenText.alternativeButtonTitle, fontName: FontNames.avenir, size: 20, color: .systemBlue)
        
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

//
//  SignUpViewController.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit
import SwiftUI

class SignUpViewController: UIViewController, UIFactory {
    let sizeScaler = UIScreen.scalableSize
    
    // -MARK: Create UI Components
    lazy var welcomeLabel: UILabel = makeLabel()
    
    lazy var invitationLabel: UILabel = makeLabel()
    
    lazy var emailLabel: UILabel = makeLabel()
    lazy var emailTextFieldContainer: UIView = makeRoundedContainer()
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
        
        view.addSubview(emailLabel)
        view.addSubview(emailTextFieldContainer)
        configEmailTextField()
        
        view.addSubview(nextButton)
        configNextButton()
        
        view.addSubview(leftDividerSubView)
        configLeftDividerSubView()
        view.addSubview(dividerLabel)
        configDivideLabel()
        view.addSubview(rightDividerSubView)
        configRightDividerSubView()
        
        view.addSubview(signUpWithGoogleButton)
        view.addSubview(alternativeStackView)
        configSignUpWithGoogleButton()
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
            //            let image = UIImage(named: ImageNames.darkCircleGroup)?.resized(to: CGSize(width: view.bounds.width / 1.5, height: view.bounds.width / 5))
            let imageView = UIImageView(image: UIImage(named: ImageNames.darkCircleGroup))
            view.addSubview(imageView)
        } else {
            //            let image = UIImage(named: ImageNames.lightCircleGroup)?.resized(to: CGSize(width: view.bounds.width / 1.5, height: view.bounds.height / 5))
            let imageView = UIImageView(image: UIImage(named: ImageNames.lightCircleGroup))
            view.addSubview(imageView)
        }
    }
    
    func configNavigation() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .systemBackground
    }
    
    func configWelcomeLabel() {
        welcomeLabel.setupTitle(text: SignUpScreenText.welcome, fontName: FontNames.avenir, size: sizeScaler(50), textColor: .systemBrown)
        welcomeLabel.setBoldText()
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 5 ),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenHeightUnit * 30),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenHeightUnit * 30)),
            welcomeLabel.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 50)
        ])
    }
    
    func configInvitationLabel() {
        invitationLabel.setupTitle(text: SignUpScreenText.invitation, fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        
        NSLayoutConstraint.activate([
            invitationLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: UIScreen.screenHeightUnit * 20),
            invitationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenHeightUnit * 30),
            invitationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenHeightUnit * 30)),
            invitationLabel.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 30)
        ])
    }
    
    func configEmailTextField() {
        emailLabel.setupTitle(text: SignUpScreenText.emailLabel, fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        emailLabel.setBoldText()
        emailLabel.textAlignment = .left
        
        emailTextFieldContainer.addRoundedTextField(emailTextField)
        emailTextField.keyboardType = .emailAddress
        
        emailTextFieldContainer.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: invitationLabel.bottomAnchor, constant: UIScreen.screenHeightUnit * 40),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 60),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 60)),
            emailLabel.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 30)
        ])
        
        NSLayoutConstraint.activate([
            emailTextFieldContainer.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: UIScreen.screenHeightUnit * 30),
            emailTextFieldContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 60),
            emailTextFieldContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 60)),
            emailTextFieldContainer.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 60)
        ])
    }
    
    func configNextButton() {
        nextButton.setTitle(title: SignUpScreenText.nextButtonTitle, fontName: FontNames.avenir, size: sizeScaler(40), color: .systemGray5)
        nextButton.cornerRadius(cornerRadius: UIScreen.screenHeightUnit * 30)
        nextButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: emailTextFieldContainer.bottomAnchor, constant: UIScreen.screenHeightUnit * 90),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 60),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 60)),
            nextButton.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 60)
        ])
    }
    
    func configLeftDividerSubView() {
        leftDividerSubView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            leftDividerSubView.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: UIScreen.screenHeightUnit * 110),
            leftDividerSubView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 60),
            leftDividerSubView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.bounds.width / 2 + 25)),
            leftDividerSubView.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 2)
        ])
    }
    
    func configDivideLabel() {
        dividerLabel.setupTitle(text: SignUpScreenText.dividerLabel, fontName: FontNames.avenir, size:  sizeScaler(30), textColor: .customBlack)
        NSLayoutConstraint.activate([
            dividerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dividerLabel.centerYAnchor.constraint(equalTo: leftDividerSubView.centerYAnchor),
            dividerLabel.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 25)
        ])
    }	
    
    func configRightDividerSubView() {
        rightDividerSubView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            rightDividerSubView.topAnchor.constraint(equalTo: leftDividerSubView.topAnchor),
            rightDividerSubView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width / 2 + 25),
            rightDividerSubView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 60)),
            rightDividerSubView.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 2)
        ])
    }
    
    func configSignUpWithGoogleButton() {
        let logoImageView: UIImageView = makeSquareImageView(imageName: ImageNames.googleLogo, size: sizeScaler(70))
        signUpWithGoogleButton.addSubview(logoImageView)
        signUpWithGoogleButton.removeBackground()
        signUpWithGoogleButton.addBorder(width: 2, color: .systemGray)
        signUpWithGoogleButton.cornerRadius(cornerRadius: UIScreen.screenHeightUnit * 30)
        signUpWithGoogleButton.setTitle(title: SignUpScreenText.signUpWithGoogleButtonTitle, fontName: FontNames.avenir, size:  sizeScaler(30), color: .customBlack)
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: signUpWithGoogleButton.leadingAnchor, constant: UIScreen.screenHeightUnit * 30),
            logoImageView.centerYAnchor.constraint(equalTo: signUpWithGoogleButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            signUpWithGoogleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 60),
            signUpWithGoogleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 60)),
            signUpWithGoogleButton.bottomAnchor.constraint(equalTo: alternativeStackView.topAnchor, constant: -(UIScreen.screenHeightUnit * 20)),
            signUpWithGoogleButton.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 60)
        ])
    }
    
    func configAlternativeStackView() {
        alternativeStackView.addArrangedSubview(alternativeLabel)
        alternativeStackView.distribution = .fillProportionally
        alternativeStackView.alignment = .center
        
        alternativeLabel.setupTitle(text: SignUpScreenText.alternativeLabel, fontName: FontNames.avenir, size: sizeScaler(28), textColor: .customBlack)
        alternativeLabel.numberOfLines = 1
        alternativeLabel.adjustsFontSizeToFitWidth = true
        
        alternativeStackView.addArrangedSubview(alternativeButton)
        alternativeButton.removeBackground()
        alternativeButton.setTitle(title: SignUpScreenText.alternativeButtonTitle, fontName: FontNames.avenir, size: sizeScaler(28), color: .systemBlue)
        
        NSLayoutConstraint.activate([
            alternativeStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(UIScreen.screenHeightUnit * 20)),
            alternativeStackView.widthAnchor.constraint(equalToConstant: UIScreen.screenWidthtUnit * 710),
            alternativeStackView.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 30),
            alternativeStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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

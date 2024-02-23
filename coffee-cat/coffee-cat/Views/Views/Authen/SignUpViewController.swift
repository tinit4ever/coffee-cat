//
//  SignUpViewController.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit
import SwiftUI

class SignUpViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: RegistrationViewModelProtocol = RegistrationViewModel()
    
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
        welcomeLabel.setupTitle(text: SignUpScreenText.welcome, fontName: FontNames.avenir, size: sizeScaler(50), textColor: .systemBrown)
        welcomeLabel.setBoldText()
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 5 ),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenHeightUnit * 30),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenHeightUnit * 30)),
            welcomeLabel.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 50)
        ])
    }
    
    private func configInvitationLabel() {
        invitationLabel.setupTitle(text: SignUpScreenText.invitation, fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        
        NSLayoutConstraint.activate([
            invitationLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: UIScreen.screenHeightUnit * 20),
            invitationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenHeightUnit * 30),
            invitationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenHeightUnit * 30)),
            invitationLabel.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 30)
        ])
    }
    
    private func configEmailTextField() {
        emailLabel.setupTitle(text: SignUpScreenText.emailLabel, fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        emailLabel.setBoldText()
        emailLabel.textAlignment = .left
        
        emailTextFieldContainer.addRoundedTextField(emailTextField)
        emailTextField.keyboardType = .emailAddress
        
        emailTextFieldContainer.backgroundColor = .textFieldContainer
        
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
    
    private func configNextButton() {
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
    
    private func configLeftDividerSubView() {
        leftDividerSubView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            leftDividerSubView.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: UIScreen.screenHeightUnit * 110),
            leftDividerSubView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.screenWidthtUnit * 60),
            leftDividerSubView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.bounds.width / 2 + 25)),
            leftDividerSubView.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 2)
        ])
    }
    
    private func configDivideLabel() {
        dividerLabel.setupTitle(text: SignUpScreenText.dividerLabel, fontName: FontNames.avenir, size:  sizeScaler(30), textColor: .customBlack)
        NSLayoutConstraint.activate([
            dividerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dividerLabel.centerYAnchor.constraint(equalTo: leftDividerSubView.centerYAnchor),
            dividerLabel.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 25)
        ])
    }
    
    private func configRightDividerSubView() {
        rightDividerSubView.backgroundColor = .gray
        NSLayoutConstraint.activate([
            rightDividerSubView.topAnchor.constraint(equalTo: leftDividerSubView.topAnchor),
            rightDividerSubView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width / 2 + 25),
            rightDividerSubView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIScreen.screenWidthtUnit * 60)),
            rightDividerSubView.heightAnchor.constraint(equalToConstant: UIScreen.screenHeightUnit * 2)
        ])
    }
    
    private func configSignUpWithGoogleButton() {
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
    
    private func configAlternativeStackView() {
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
    
    // -MARK: Setup Action
    private func setupAction() {
        emailTextField.delegate = self
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        alternativeButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    // -MARK: Catch Action
    @objc
    private func nextButtonTapped() {
        self.showLoadingView()
        guard let email = emailTextField.text,
              self.viewModel.validateEmail(email) else {
            displayInvalidEmailAlert(self.viewModel.alertMessage)
            self.viewModel.alertMessage = ""
            self.hiddenLoadingView()
            return
        }
        
        let createPasswordViewController = CreatePasswordViewController()
        createPasswordViewController.viewModel = self.viewModel
        
        self.hiddenLoadingView()
        pushViewController(viewController: createPasswordViewController)
    }
    
    @objc
    private func signUpButtonTapped() {
        pushViewController(viewController: SignInViewController())
    }
    
    // -MARK: Utilities
    private func displayInvalidEmailAlert(_ message: String) {
        let alert = UIAlertController(title: "Invalid Email", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
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

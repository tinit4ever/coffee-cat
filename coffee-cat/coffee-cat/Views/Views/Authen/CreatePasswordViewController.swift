//
//  CreatePasswordViewController.swift
//  coffee-cat
//
//  Created by Tin on 31/01/2024.
//

import UIKit
import SwiftUI

class CreatePasswordViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: RegistrationViewModelProtocol?
    
    // -MARK: Create UI Components
    lazy var scrollViewContainer = makeScrollViewContainer()
    
    lazy var animationView = makeLottieAnimationView(animationName: "authentication")
    
    lazy var passwordStackView: UIStackView = makeVerticalStackView()
    lazy var passwordLabel: UILabel = makeLabel()
    lazy var passwordTextFieldContainer: UIView = makeRoundedContainer()
    lazy var passwordTextField: UITextField = makeTextField(placeholder: "Password")
    
    lazy var confirmPasswordStackView: UIStackView = makeVerticalStackView()
    lazy var confirmPasswordLabel: UILabel = makeLabel()
    lazy var confirmPasswordTextFieldContainer: UIView = makeRoundedContainer()
    lazy var confirmPasswordTextField: UITextField = makeTextField(placeholder: "Confirm Password")
    
    lazy var nextButton: UIButton = makeButton()
    
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
        
        view.addSubview(scrollViewContainer)
        configScrollViewContainter()
        
        scrollViewContainer.addSubview(animationView)
        animationView.play()
        configAnimationView()
        
        scrollViewContainer.addSubview(passwordStackView)
        configPasswordStackView()
        
        scrollViewContainer.addSubview(confirmPasswordStackView)
        configConfirmPasswordStackView()
        
        scrollViewContainer.addSubview(nextButton)
        configNextButton()
        
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
    
    private func configScrollViewContainter() {
        NSLayoutConstraint.activate([
            scrollViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            scrollViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollViewContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollViewContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configAnimationView() {
        animationView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: scrollViewContainer.topAnchor, constant: heightScaler(160)),
            animationView.widthAnchor.constraint(equalToConstant: sizeScaler(460)),
            animationView.heightAnchor.constraint(equalToConstant: sizeScaler(400)),
            animationView.centerXAnchor.constraint(equalTo: scrollViewContainer.centerXAnchor)
        ])
    }
    
    private func configPasswordStackView() {
        passwordStackView.spacing = heightScaler(10)
        passwordStackView.contentMode = .topLeft
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordLabel.setupTitle(text: "Password", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        passwordLabel.setBoldText()
        passwordLabel.textAlignment = .left
        
        passwordStackView.addArrangedSubview(passwordTextFieldContainer)
        passwordTextFieldContainer.addRoundedTextField(passwordTextField)
        passwordTextFieldContainer.backgroundColor = .textFieldContainer
        
        NSLayoutConstraint.activate([
            passwordStackView.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: heightScaler(60)),
            passwordStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            passwordStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
        ])
        NSLayoutConstraint.activate([
            passwordTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    private func configConfirmPasswordStackView() {
        confirmPasswordStackView.spacing = heightScaler(10)
        confirmPasswordStackView.contentMode = .topLeft
        confirmPasswordStackView.addArrangedSubview(confirmPasswordLabel)
        confirmPasswordLabel.setupTitle(text: "Confirm Password", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        confirmPasswordLabel.setBoldText()
        confirmPasswordLabel.textAlignment = .left
        
        confirmPasswordStackView.addArrangedSubview(confirmPasswordTextFieldContainer)
        confirmPasswordTextFieldContainer.addRoundedTextField(confirmPasswordTextField)
        confirmPasswordTextFieldContainer.backgroundColor = .textFieldContainer
        
        NSLayoutConstraint.activate([
            confirmPasswordStackView.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: heightScaler(20)),
            confirmPasswordStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            confirmPasswordStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
        ])
        NSLayoutConstraint.activate([
            confirmPasswordTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    private func configNextButton() {
        nextButton.cornerRadius(cornerRadius: heightScaler(30))
        nextButton.setTitle(title: "Next", fontName: FontNames.avenir, size: sizeScaler(40), color: .systemGray5)
        nextButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -heightScaler(60)),
            nextButton.heightAnchor.constraint(equalToConstant: heightScaler(60))
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
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func nextButtonTapped() {
        self.showLoadingView()
        guard let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text,
              self.viewModel!.validatePassword(password, confirmPassword) else {
            displayInvalidPassword(self.viewModel!.alertMessage)
            self.viewModel?.alertMessage = ""
            self.hiddenLoadingView()
            return
        }
        
        let userProfileInputViewController = UserProfileInputViewController()
        userProfileInputViewController.viewModel = self.viewModel
        
        pushViewController(viewController: userProfileInputViewController)
        hiddenLoadingView()
    }
    
    // -MARK: Utilities
    private func displayInvalidPassword(_ message: String) {
        let alert = UIAlertController(title: "Input Error", message: message, preferredStyle: .alert)
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

extension CreatePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
    }
}

// -MARK: Preview
struct CreatePasswordViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let createPasswordViewControllerPreview = CreatePasswordViewController()
            return createPasswordViewControllerPreview
        }
    }
}



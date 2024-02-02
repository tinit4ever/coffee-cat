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
    
    // -MARK: Create UI Components
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
        
        view.addSubview(animationView)
        animationView.play()
        configAnimationView()
        
        view.addSubview(passwordStackView)
        configPasswordStackView()
        
        view.addSubview(confirmPasswordStackView)
        configConfirmPasswordStackView()
        
        view.addSubview(nextButton)
        configNextButton()
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
    let backImage = UIImage(systemName: "chevron.backward.circle.fill")?
        .withTintColor(.backButton, renderingMode: .alwaysOriginal)
        .resized(to: CGSize(width: sizeScaler(50), height: sizeScaler(50)))
    
    self.navigationController?.navigationBar.backIndicatorImage = backImage
    self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    self.navigationItem.backBarButtonItem?.tintColor = .backButton
}
    
    private func configAnimationView() {
        animationView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 6),
            animationView.widthAnchor.constraint(equalToConstant: sizeScaler(400)),
            animationView.heightAnchor.constraint(equalToConstant: sizeScaler(350)),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configPasswordStackView() {
        passwordStackView.spacing = heightScaler(20)
        passwordStackView.contentMode = .topLeft
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordLabel.setupTitle(text: "Password", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        passwordLabel.setBoldText()
        passwordLabel.textAlignment = .left
        
        passwordStackView.addArrangedSubview(passwordTextFieldContainer)
        passwordTextFieldContainer.addRoundedTextField(passwordTextField)
        passwordTextFieldContainer.backgroundColor = .textFieldContainer
        
        NSLayoutConstraint.activate([
            passwordStackView.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: heightScaler(40)),
            passwordStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            passwordStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
        ])
        NSLayoutConstraint.activate([
            passwordTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    private func configConfirmPasswordStackView() {
        confirmPasswordStackView.spacing = heightScaler(20)
        confirmPasswordStackView.contentMode = .topLeft
        confirmPasswordStackView.addArrangedSubview(confirmPasswordLabel)
        confirmPasswordLabel.setupTitle(text: "Confirm Password", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        confirmPasswordLabel.setBoldText()
        confirmPasswordLabel.textAlignment = .left
        
        confirmPasswordStackView.addArrangedSubview(confirmPasswordTextFieldContainer)
        confirmPasswordTextFieldContainer.addRoundedTextField(confirmPasswordTextField)
        confirmPasswordTextFieldContainer.backgroundColor = .textFieldContainer
        
        NSLayoutConstraint.activate([
            confirmPasswordStackView.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: heightScaler(60)),
            confirmPasswordStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            confirmPasswordStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
        ])
        NSLayoutConstraint.activate([
            confirmPasswordTextFieldContainer.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    func configNextButton() {
        nextButton.cornerRadius(cornerRadius: heightScaler(30))
        nextButton.setTitle(title: "Next", fontName: FontNames.avenir, size: sizeScaler(40), color: .systemGray5)
        nextButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -heightScaler(60)),
            nextButton.heightAnchor.constraint(equalToConstant: heightScaler(60))
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
        pushViewController(viewController: UserProfileInputViewController())
    }
}

extension CreatePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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


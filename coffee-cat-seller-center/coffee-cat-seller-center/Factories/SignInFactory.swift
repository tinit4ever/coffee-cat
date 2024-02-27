//
//  SignInFactory.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 26/02/2024.
//

import UIKit
import Lottie

protocol SignInFactory {
    func makeLabel() -> UILabel
    func makeButton() -> UIButton
    func makeLottieAnimationView(animationName: String) -> LottieAnimationView
    func makeHorizontalStackView() -> UIStackView
    func makeTextField(placeholder: String) -> UITextField
    func makeRoundedContainer() -> UIView
}

extension SignInFactory {
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func makeLottieAnimationView(animationName: String) -> LottieAnimationView {
        let animationView: LottieAnimationView
        animationView = .init(name: animationName)
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }
    
    func makeHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func makeTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func makeRoundedContainer() -> UIView {
        let container = UIView()
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.systemGray3.cgColor
        container.layer.cornerRadius = UIScreen.screenHeightUnit * 15
        container.layer.masksToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }
}

//
//  ShopCreationInputFactory.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 07/03/2024.
//

import Foundation
import UIKit
import Lottie

protocol ShopCreationInputFactory {
    func makeLabel() -> UILabel
    func makeVerticalStackView() -> UIStackView
    func makeHorizontalStackView() -> UIStackView
    func makeRoundedContainer() -> UIView
    func makeTextField(placeholder: String) -> UITextField
    func makeLottieAnimationView(animationName: String) -> LottieAnimationView
}

extension ShopCreationInputFactory {
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeVerticalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func makeHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    func makeTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func makeLottieAnimationView(animationName: String) -> LottieAnimationView {
        let animationView: LottieAnimationView
        animationView = .init(name: animationName)
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }
}

//
//  AccountInputFactory.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 01/03/2024.
//

import UIKit

protocol AccountInputFactory {
    func makeLabel() -> UILabel
    func makeVerticalStackView() -> UIStackView
    func makeHorizontalStackView() -> UIStackView
    func makeRoundedContainer() -> UIView
    func makeTextField(placeholder: String) -> UITextField
}

extension AccountInputFactory {
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
}

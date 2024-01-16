//
//  GettingStartedFactory.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit

protocol GettingStartedFactory {
    func makeLabel() -> UILabel
    func makeButton(backgroundColor: UIColor) -> UIButton
    func makeTextField(placeholder: String) -> UITextField
}

extension GettingStartedFactory {
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeButton(backgroundColor: UIColor) -> UIButton {
        let button = UIButton()
        var configuration = UIButton.Configuration.gray()
        configuration.baseBackgroundColor = backgroundColor
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func makeTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}

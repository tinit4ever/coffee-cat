//
//  GettingStartedFactory.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit

protocol UIFactory {
    func makeLabel() -> UILabel
    func makeButton() -> UIButton
    func makeTextField() -> UITextField
}

extension UIFactory {
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
    
    func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}

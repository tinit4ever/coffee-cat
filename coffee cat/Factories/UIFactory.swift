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
    func makeTextField(placeholder: String) -> UITextField
    func makeRoundedTextFieldContainer() -> UIView
    func makeView() -> UIView
    func makeVerticalStackView() -> UIStackView
    func makeHorizontalStackView() -> UIStackView
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
    
    func makeTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = placeholder
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func makeRoundedTextFieldContainer() -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }
    
    func makeView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    func makeSquareImageView(imageName: String, size: CGFloat) -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        if let image = UIImage(named: imageName) {
            imageView.image = image.resized(to: CGSize(width: size, height: size))
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

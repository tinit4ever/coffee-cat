//
//  CatFactory.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 08/03/2024.
//

import Foundation
import UIKit
import Lottie

protocol CatFactory {
    func makeLabel() -> UILabel
    func makeButton() -> UIButton
    func makeDatePicker() -> UIDatePicker
    func makeHorizontalStackView() -> UIStackView
}

extension CatFactory {
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
    
    func makeDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }
    
    func makeHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}

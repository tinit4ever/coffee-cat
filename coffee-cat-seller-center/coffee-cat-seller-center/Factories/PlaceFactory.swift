//
//  PlaceFactory.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 03/03/2024.
//

import UIKit
import Lottie

protocol PlaceFactory {
    func makeLabel() -> UILabel
    func makeButton() -> UIButton
    func makeDatePicker() -> UIDatePicker
    func makeHorizontalStackView() -> UIStackView
}

extension PlaceFactory {
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

//
//  UIView+Extension.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit

extension UIView {
    func addRoundedTextField(_ textField: UITextField) {
        self.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIScreen.screenHeightUnit * 30),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(UIScreen.screenHeightUnit * 30)),
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

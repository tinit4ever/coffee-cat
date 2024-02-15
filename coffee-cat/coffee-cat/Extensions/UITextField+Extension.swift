//
//  UITextField+Extension.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit

extension UITextField {
    func showPasswordButton(showPasswordButton: UIButton) {
        self.rightView = showPasswordButton
        self.rightViewMode = .always
    }
}

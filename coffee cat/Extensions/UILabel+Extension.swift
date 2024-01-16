//
//  UILabel+Extension.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit

extension UILabel {
    func setupTitle(text: String, fontName: String, size: CGFloat, textColor: UIColor) {
        let font = UIFont(name: fontName, size: size)
        self.textAlignment = .center
        self.font = font
        self.textColor = textColor
        self.text = text
    }
}

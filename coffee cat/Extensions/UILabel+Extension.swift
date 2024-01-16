//
//  UILabel+Extension.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit

extension UILabel {
    func customizeLabel(fontName: String, size: CGFloat, textColor: UIColor) {
        var font = UIFont(name: fontName, size: size)
        self.textAlignment = .center
        self.font = font
        self.textColor = textColor
    }
}

//
//  UILabel+Extension.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit

extension UILabel {
    func setupTitle(text: String, fontName: String, size: CGFloat, textColor: UIColor) {
        if let font = UIFont(name: fontName, size: size) {
            self.font = font
        }
        
        self.textAlignment = .center
        self.textColor = textColor
        self.text = text
    }
    
    func setBoldText() {
        if let currentFont = self.font {
            let boldFont = UIFont(descriptor: currentFont.fontDescriptor.withSymbolicTraits(.traitBold)!, size: currentFont.pointSize)
            self.font = boldFont
        }
    }
}

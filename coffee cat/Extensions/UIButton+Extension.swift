//
//  UIButton+Extension.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit

extension UIButton {
    func makeCornerRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    
    func makeTitle(title: String, fontName: String, size: CGFloat, color: UIColor) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(.darkGray, for: .highlighted)

        var configuration = self.configuration ?? UIButton.Configuration.gray()
        configuration.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: fontName, size: size)
            
            if let descriptor = outgoing.font?.fontDescriptor {
                outgoing.font = UIFont(descriptor: descriptor.withSymbolicTraits(.traitBold)!, size: size)
            }
            
            return outgoing
        }
        
        self.configuration = configuration
    }
    
    func makeNoBorderButton() {
        let configuration = UIButton.Configuration.plain()
        self.configuration = configuration
    }
}

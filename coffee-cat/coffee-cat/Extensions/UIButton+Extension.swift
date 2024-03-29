//
//  UIButton+Extension.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit

extension UIButton {
    func cornerRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func setTitle(title: String, fontName: String, size: CGFloat, color: UIColor) {
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
        self.tintColor = color
    }
    
    func setBackgroundColor(backgroundColor: UIColor) {
        var configuration = self.configuration ?? UIButton.Configuration.gray()
        configuration.baseBackgroundColor = backgroundColor
        self.configuration = configuration
    }
    
    func setFont(fontName: String, size: CGFloat) {
        var configuration = self.configuration ?? UIButton.Configuration.gray()
        configuration.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: fontName, size: size)
            return outgoing
        }
        self.configuration = configuration
    }
    
    func setBoldFont(fontName: String, size: CGFloat) {
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
    
    func removeBackground() {
        let configuration = UIButton.Configuration.plain()
        self.configuration = configuration
    }
    
    func showPasswordButton() {
        self.setImage(UIImage(systemName: SystemImageNames.eyeSlash), for: .normal)
        self.tintColor = .systemGray
    }
    
    func ratioButton(_ isSelected: Bool) {
        self.widthAnchor.constraint(equalToConstant: UIScreen.scalableSize(34)).isActive = true
        self.heightAnchor.constraint(equalToConstant: UIScreen.scalableSize(34)).isActive = true
        var configuration = UIButton.Configuration.plain()
        
        let symbolName = isSelected ? "largecircle.fill.circle" : "circle"
        if let image = UIImage(systemName: symbolName) {
            let imageConfiguration = UIImage.SymbolConfiguration(weight: .bold)
            let newImage = image.applyingSymbolConfiguration(imageConfiguration)
            configuration.image = newImage
        }
        
        configuration.buttonSize = .large
        configuration.imagePadding = 0
        configuration.baseForegroundColor = .systemPurple
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        self.configuration = configuration
    }
    
}

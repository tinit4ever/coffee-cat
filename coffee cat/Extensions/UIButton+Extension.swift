//
//  UIButton+Extension.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit

extension UIButton {
    func customizeButton(cornerRadius: CGFloat) {
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.setTitle("Get Started", for: .normal)
        self.setTitleColor(.white, for: .normal)
    }
}

//        getStartedButton.layer.cornerRadius = 20
//        getStartedButton.layer.masksToBounds = true
//        getStartedButton.setTitle("Get Started", for: .normal)
//        getStartedButton.setTitleColor(.white, for: .normal)
//        getStartedButton.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 20)

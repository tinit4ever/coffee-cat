//
//  UIFont+Extension.swift
//  coffee-cat
//
//  Created by Tin on 29/01/2024.
//

import UIKit

extension UIFont {
    static func scaledFont(size: CGFloat) -> UIFont {
        let screenScale = (UIScreen.main.bounds.height + UIScreen.main.bounds.width) / 2000
        let scaledSize = size * screenScale
        return UIFont.systemFont(ofSize: scaledSize)
    }
}

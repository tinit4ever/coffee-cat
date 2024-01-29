//
//  UIScreen+Extension.swift
//  coffee cat
//
//  Created by Tin on 25/01/2024.
//

import UIKit

extension UIScreen {
    //Old implement
    static var screenHeightUnit: CGFloat {
        return UIScreen.main.bounds.height / 1000
    }
    static var screenWidthtUnit: CGFloat {
        return UIScreen.main.bounds.width / 1000
    }
    
    //New implement
    static let scalableHeight: (CGFloat) -> CGFloat = { size in
        return (UIScreen.main.bounds.height / 1000) * size
    }
    
    static let scalableWidth: (CGFloat) -> CGFloat = { size in
        return (UIScreen.main.bounds.width / 1000) * size
    }
    
    static let scalableSize: (CGFloat) -> CGFloat = { size in
        let screenHeightScale = UIScreen.main.bounds.height / 1000
        let screenWidthScale = UIScreen.main.bounds.width / 1000
        let averageScale = (screenHeightScale + screenWidthScale) / 2
        let scaledSize = size * averageScale
        return scaledSize
    }
}


//
//  UIScreen+Extension.swift
//  coffee cat
//
//  Created by Tin on 25/01/2024.
//

import UIKit

extension UIScreen {
    static var screenHeightUnit: CGFloat {
        return UIScreen.main.bounds.height / 1000
    }
    
    static var screenWidthtUnit: CGFloat {
        return UIScreen.main.bounds.width / 1000
    }
}


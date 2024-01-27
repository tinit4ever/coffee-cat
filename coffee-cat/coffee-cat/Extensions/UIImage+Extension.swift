//
//  UIImage+Extension.swift
//  coffee cat
//
//  Created by Tin on 17/01/2024.
//

import UIKit

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

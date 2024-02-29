//
//  UISegmentedControl + Extension.swift
//  coffee-cat
//
//  Created by Tin on 29/02/2024.
//

import UIKit

class SquareSegmentedControl: UISegmentedControl {
    private let segmentInset: CGFloat = 8      //your inset amount
    private let segmentImage: UIImage? = UIImage(color: UIColor.systemGray)
    
    override func layoutSubviews(){
            super.layoutSubviews()

            //background
            layer.cornerRadius = bounds.height/2
            //foreground
            let foregroundIndex = numberOfSegments
            if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView
            {
                foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
                foregroundImageView.image = segmentImage
                foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")
                foregroundImageView.layer.masksToBounds = true
                foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height/2
            }
        }

}

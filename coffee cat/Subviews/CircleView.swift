//
//  CircleView.swift
//  coffee cat
//
//  Created by Tin on 19/01/2024.
//

import UIKit

class CircleView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setFillColor(UIColor.red.cgColor)

        context.fillEllipse(in: rect)
    }
}

//
//  DatePicker+Extension.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 03/03/2024.
//

import UIKit

class RemoveCornerDatePicker: UIDatePicker {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = true
    }
}

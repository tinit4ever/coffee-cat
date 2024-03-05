//
//  String+Extension.swift
//  coffee-cat
//
//  Created by Tin on 16/02/2024.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        let phoneRegex = "^((\\+84)|(0))\\d{9,10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }
    
    func isNumber() -> Bool {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self) != nil
    }
}

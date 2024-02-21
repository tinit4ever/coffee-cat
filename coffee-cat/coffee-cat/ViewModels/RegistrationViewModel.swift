//
//  RegistrationViewModel.swift
//  coffee-cat
//
//  Created by Tin on 16/02/2024.
//

import Foundation
import Alamofire

protocol RegistrationViewModelProtocol {
    var userRegistration: UserRegistration {get set}
    var alertMessage: String {get set}
    
    func validateEmail(_ email: String) -> Bool
    func updateEmail(_ email: String)
    
    func validatePassword(_ password: String, _ confirmPassword: String) -> Bool
    func updatePassword(_ password: String)
    
    func validateName(_ name: String) -> Bool
    func validatePhoneNumber(_ phoneNumber: String) -> Bool
    func validateDob(_ dob: Date) -> Bool
    
    func updateUserProfile(_ name: String, _ phoneNumber: String, _ dob: Date, _ gender: String)
    
    func registerUser(completion: @escaping (Result<String, Error>) -> Void)
}

class RegistrationViewModel {
    var userRegistration: UserRegistration
    var alertMessage: String
    
    init() {
        self.alertMessage = ""
        self.userRegistration = UserRegistration(email: "", password: "", phone: "", name: "", dob: "", gender: "")
    }
}

extension RegistrationViewModel: RegistrationViewModelProtocol {
    func validateEmail(_ email: String) -> Bool {
        if email.isValidEmail {
            updateEmail(email)
            return true
        } else {
            self.alertMessage = "Please enter a valid email"
            return false
        }
    }
    
    func updateEmail(_ email: String) {
        self.userRegistration.email = email
    }
    
    func validatePassword(_ password: String, _ confirmPassword: String) -> Bool {
        if password != confirmPassword {
            self.alertMessage = "Confirm password is not match"
            return false
        } else {
            updatePassword(password)
            return true
        }
    }
    
    func updatePassword(_ password: String) {
        self.userRegistration.password = password
    }
    
    func validateName(_ name: String) -> Bool {
        if name.count > 23 {
            self.alertMessage = "Name too long"
            return false
        } else if name.isEmpty {
            self.alertMessage = "Name is not allow empty"
            return false
        } else {
            return true
        }
    }
    
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        if phoneNumber.isValidPhoneNumber {
            return true
        } else {
            self.alertMessage = "Phone number format is wrong"
            return false
        }
    }
    
    func validateDob(_ dob: Date) -> Bool {
        let selectedDate = dob
        let currentDate = Date()
        
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: selectedDate, to: currentDate)
        
        if (ageComponents.year ?? 0) >= 10 {
            return true
        } else {
            self.alertMessage = "Sorry, users less than 10 years old are not allowed."
            return false
        }
    }
    
    func updateUserProfile(_ name: String, _ phoneNumber: String, _ dob: Date, _ gender: String) {
        self.userRegistration.name = name
        self.userRegistration.phone = phoneNumber
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateFormatterToStore
        self.userRegistration.dob = dateFormatter.string(from: dob)
        
        self.userRegistration.gender = gender
        print(userRegistration)
    }
    
    func registerUser(completion: @escaping (Result<String, Error>) -> Void) {
        let userData = self.userRegistration
        
        AF.request("http://localhost:8080/auth/register", method: .post, parameters: userData, encoder: JSONParameterEncoder.default).responseString { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

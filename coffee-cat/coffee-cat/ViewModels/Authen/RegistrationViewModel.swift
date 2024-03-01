//
//  RegistrationViewModel.swift
//  coffee-cat
//
//  Created by Tin on 16/02/2024.
//

import Foundation
import Alamofire
import Combine

protocol RegistrationViewModelProtocol {
    var userRegistration: UserRegistration {get set}
    var alertMessage: String {get set}
    
    func checkEmailExisted(email: String) -> AnyPublisher<Bool, Error>
    
    func validateEmail(_ email: String) -> Bool
    func updateEmail(_ email: String)
    
    func validatePassword(_ password: String, _ confirmPassword: String) -> Bool
    func updatePassword(_ password: String)
    
    func validateName(_ name: String) -> Bool
    func validatePhoneNumber(_ phoneNumber: String) -> Bool
    func validateDob(_ dob: Date) -> Bool
    
    func updateUserProfile(_ name: String, _ phoneNumber: String, _ dob: Date, _ gender: String)
    func setNullUserProfile() 
    
    func registerUser(completion: @escaping (Result<AuthenticationResponse, Error>) -> Void)
}

class RegistrationViewModel {
    var userRegistration: UserRegistration
    var alertMessage: String
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        self.alertMessage = ""
        self.userRegistration = UserRegistration(email: "", password: "", phone: "", name: "", dob: "", gender: "")
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

extension RegistrationViewModel: RegistrationViewModelProtocol {
    func checkEmailExisted(email: String) -> AnyPublisher<Bool, Error> {
        return APIManager.shared.checkEmailExisted(email: email)
            .map { authenticationResponse in
                return !(authenticationResponse.status ?? true)
            }
            .eraseToAnyPublisher()
    }
    
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
        if password.count < 8 || confirmPassword.count < 8 {
            self.alertMessage = "Password must be least 8 letters"
            return false
        }
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
    
    func setNullUserProfile() {
        self.userRegistration.name = nil
        self.userRegistration.phone = nil
        self.userRegistration.dob = nil
        self.userRegistration.gender = nil
    }
    
    func registerUser(completion: @escaping (Result<AuthenticationResponse, Error>) -> Void) {
        APIManager.shared.signUp(userRegistration: self.userRegistration, completion: completion)
    }
}

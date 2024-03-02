//
//  AccountInputViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 01/03/2024.
//

import Foundation
import Combine

protocol AccountInputViewModelProtocol {
    var userRegistration: UserRegistration? {get set}
    var alertMessage: String {get set}
    
    func checkEmailExisted(email: String) -> AnyPublisher<Bool, Error>
    func validateEmail(_ email: String) -> Bool
    func validatePassword(_ password: String, _ confirmPassword: String) -> Bool
    func validateName(_ name: String) -> Bool
    func setUserRegistration(name: String, email: String, password: String)
    func getUserRegistration() -> UserRegistration
    func createAccount()
}

class AccountInputViewModel: AccountInputViewModelProtocol {
    var userRegistration: UserRegistration?
    
    var alertMessage: String = ""
    var cancellables: Set<AnyCancellable> = []
}

extension AccountInputViewModel {
    func checkEmailExisted(email: String) -> AnyPublisher<Bool, Error> {
        return APIManager.shared.checkEmailExisted(email: email)
            .map { authenticationResponse in
                return !(authenticationResponse.status ?? true)
            }
            .eraseToAnyPublisher()
    }
    
    func validateEmail(_ email: String) -> Bool {
        if email.isValidEmail {
            return true
        } else {
            self.alertMessage = "Please enter a valid email"
            return false
        }
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
            return true
        }
    }

    func validateName(_ name: String) -> Bool {
        if name.count > /*23*/ 5 {
            self.alertMessage = "Name too long"
            return false
        } else if name.isEmpty {
            self.alertMessage = "Name is not allow empty"
            return false
        } else {
            return true
        }
    }
    
    func setUserRegistration(name: String, email: String, password: String) {
        self.userRegistration?.name = name
        self.userRegistration?.email = email
        self.userRegistration?.password = password
    }
    
    func getUserRegistration() -> UserRegistration {
        self.userRegistration ?? UserRegistration(name: "", email: "", password: "")
    }

    func createAccount() {
//        APIManager.shared.signUp(userRegistration: self.userRegistration, completion: completion)
    }
}

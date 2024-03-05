//
//  AccountInputViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 01/03/2024.
//

import Foundation
import Combine

protocol AccountInputViewModelProtocol: AnyObject {
    var initEmailWhenUpdate: String? {get set}
    var accountCreation: CreateAccountModel? {get set}
    var alertMessage: String {get set}
    var accountCreationResultSubject: PassthroughSubject<Result<Void, Error>, Never> {get}
    var accountUpdateResultSubject: PassthroughSubject<Result<Void, Error>, Never> {get}
    
    func checkEmailExisted(email: String) -> AnyPublisher<Bool, Error>
    func validateEmail(_ email: String) -> Bool
    func validatePhoneNumber(_ phoneNumber: String) -> Bool
    func validatePassword(_ password: String, _ confirmPassword: String) -> Bool
    func validateName(_ name: String) -> Bool
    func setId(id: Int)
    func setPhone(phone: String)
    func setName(name: String)
    func setEmail(email: String)
    func setPassword(password: String)
    func getUserRegistration() -> CreateAccountModel
    func createAccount(model: CreateAccountModel, accessToken: String)
    func updateAccount(model: CreateAccountModel, accessToken: String)
}

class AccountInputViewModel: AccountInputViewModelProtocol {
    var initEmailWhenUpdate: String?
    
    var accountCreation: CreateAccountModel?
    var accountCreationResultSubject = PassthroughSubject<Result<Void, Error>, Never>()
    var accountUpdateResultSubject = PassthroughSubject<Result<Void, Error>, Never>()
    
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
    
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        if phoneNumber.isValidPhoneNumber {
            return true
        } else {
            self.alertMessage = "Phone number format is wrong"
            return false
        }
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
    
    func setId(id: Int) {
        self.accountCreation?.staffId = id
    }
    
    func setName(name: String) {
        self.accountCreation?.name = name
    }
    
    func setPhone(phone: String) {
        self.accountCreation?.phone = phone
    }
    
    func setEmail(email: String) {
        self.accountCreation?.email = email
    }
    
    func setPassword(password: String) {
        self.accountCreation?.password = password
    }
    
    func getUserRegistration() -> CreateAccountModel {
        self.accountCreation ?? CreateAccountModel(email: "", password: "", name: "", phone: "")
    }

    func createAccount(model: CreateAccountModel, accessToken: String) {
        return APIManager.shared.createStaff(with: model, accessToken: accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.accountCreationResultSubject.send(.failure(error))
                }
            } receiveValue: {
                self.accountCreationResultSubject.send(.success(()))
            }
            .store(in: &cancellables)
    }
    
    func updateAccount(model: CreateAccountModel, accessToken: String) {
        return APIManager.shared.updateStaff(with: model, accessToken: accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.accountUpdateResultSubject.send(.failure(error))
                }
            } receiveValue: {
                self.accountUpdateResultSubject.send(.success(()))
            }
            .store(in: &cancellables)
    }
}

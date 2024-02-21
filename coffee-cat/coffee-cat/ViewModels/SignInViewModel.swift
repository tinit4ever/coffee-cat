//
//  SignInViewModel.swift
//  coffee-cat
//
//  Created by Tin on 16/02/2024.
//

import Foundation

protocol SignInViewModelProtocol {
    func signIn()
}

class SignInViewModel {
    
}

extension SignInViewModel: SignInViewModelProtocol {
    func signIn() {
        print("Login")
    }
}

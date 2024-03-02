//
//  SignInViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 02/03/2024.
//

protocol SignInViewModelProtocol {
    func signIn(_ email: String, _ password: String, completion: @escaping (Result<AuthenticationResponse, Error>) -> Void)
}

class SignInViewModel {}

extension SignInViewModel: SignInViewModelProtocol {
    func signIn(_ email: String, _ password: String, completion: @escaping (Result<AuthenticationResponse, Error>) -> Void) {
        APIManager.shared.signIn(email: email, password: password, completion: completion)
    }
}

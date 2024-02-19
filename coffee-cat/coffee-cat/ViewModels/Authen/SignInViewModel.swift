// SignInViewModel.swift
// coffee-cat
// Created by Tin on 16/02/2024.

import Foundation
import Alamofire

protocol SignInViewModelProtocol {
    func signIn(_ email: String, _ password: String, completion: @escaping (Result<AuthenticationResponse, Error>) -> Void)
}

class SignInViewModel {}

extension SignInViewModel: SignInViewModelProtocol {
    func signIn(_ email: String, _ password: String, completion: @escaping (Result<AuthenticationResponse, Error>) -> Void) {
        APIManager.shared.signIn(email: email, password: password, completion: completion)
    }
}

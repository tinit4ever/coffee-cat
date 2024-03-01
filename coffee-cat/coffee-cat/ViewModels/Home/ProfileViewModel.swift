//
//  ProfileViewModel.swift
//  coffee-cat
//
//  Created by Tin on 27/02/2024.
//

import Foundation

protocol ProfileViewModelProtocol {
    func logout(accessToken: String, completion: @escaping (Result<AuthenticationResponse, Error>) -> Void)
}

class ProfileViewModel: ProfileViewModelProtocol {
    func logout(accessToken: String, completion: @escaping (Result<AuthenticationResponse, Error>) -> Void) {
        APIManager.shared.logout(accessToken: accessToken, completion: completion)
    }
}

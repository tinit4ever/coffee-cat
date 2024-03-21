//
//  ProfileViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 02/03/2024.
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

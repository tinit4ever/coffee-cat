//
//  ProfileViewModel.swift
//  coffee-cat
//
//  Created by Tin on 27/02/2024.
//

import Foundation

protocol ProfileViewModelProtocol {
    func logout()
}

class ProfileViewModel: ProfileViewModelProtocol {
    func logout() {
        print("Logout")
    }
}

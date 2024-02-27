//
//  ProfileViewModel.swift
//  coffee-cat
//
//  Created by Tin on 27/02/2024.
//

import Foundation

protocol ProfileViewModelProtocol {
    var userInfo: Account {get set}
    
    func logout()
}

class ProfileViewModel: ProfileViewModelProtocol {
    var userInfo: Account
    
    init(userInfo: Account) {
        self.userInfo = userInfo
    }
    
    func logout() {
        print("Logout")
    }
}

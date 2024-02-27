//
//  AuthenticationResponse.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation

struct AuthenticationResponse: Codable {
    var access_token: String?
    var refresh_token: String?
    var message: String?
    var status: Bool?
    var accountResponse: Account?
}

struct Account: Codable {
    var id: Int?
    var email: String?
    var username: String?
    var phone: String?
    var gender: String?
    var dob: String?
    var status: String?
    var role: String?
}

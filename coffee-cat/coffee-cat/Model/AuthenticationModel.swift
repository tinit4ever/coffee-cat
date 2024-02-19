//
//  UserRegistration.swift
//  coffee-cat
//
//  Created by Tin on 16/02/2024.
//

struct UserRegistration: Codable {
    var email: String
    var password: String
    var phone: String
    var name: String
    var dob: String
    var gender: String
}

struct RegistrationResponse: Codable {
    let status: Bool
    let message: String
    let accessToken: String
}

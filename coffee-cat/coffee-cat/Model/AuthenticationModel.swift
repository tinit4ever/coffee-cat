//
//  UserRegistration.swift
//  coffee-cat
//
//  Created by Tin on 16/02/2024.
//

struct UserRegistration: Codable {
    var email: String
    var password: String
    var phone: String?
    var name: String?
    var dob: String?
    var gender: String?
}

struct UserSignIn: Codable {
    var email: String
    var password: String
}

//
//  AuthenticationResponse.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation

struct AuthenticationResponse: Codable {
    var accessToken: String?
    var refreshToken: String?
    var message: String?
    var status: Bool?
    var accountResponse: Account?
}

struct Account: Codable {
    var id: Int
    var email: String
    var name: String?
    var phone: String?
    var gender: String?
    var dob: String?
    var status: Status
    var role: Role
}

enum Role: String, Codable {
    case admin = "ADMIN"
    case shopOwner = "OWNER"
    case staff = "STAFF"
    case customer = "CUSTOMER"
}
enum Status: String, Codable {
    case active = "active"
    case inactive = "inactive"
}

//
//  AccountModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 01/03/2024.
//

import Foundation

struct UserRegistration: Codable {
    var name: String
    var email: String
    var password: String
}

struct Account: Codable {
    var id: Int
    var email: String
    var name: String?
    var phone: String?
    var gender: String?
    var dob: String?
    var status: Status
    var role: Role?
    var shopId: Int?
    var shopName: String?
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

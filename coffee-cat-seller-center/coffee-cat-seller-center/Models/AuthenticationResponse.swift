//
//  AuthenticationResponse.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 01/03/2024.
//

import Foundation

struct AuthenticationResponse: Codable {
    var accessToken: String?
    var refreshToken: String?
    var message: String?
    var status: Bool?
    var accountResponse: Account?
}

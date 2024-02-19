//
//  LoginResponse.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation

struct AuthenticationResponse: Codable {
    let message: String
    let accessToken: String
    let refreshToken: String
}

//
//  UserSessionManager.swift
//  coffee-cat
//
//  Created by Tin on 27/02/2024.
//

import Foundation

class UserSessionManager {
    static let shared = UserSessionManager()

        private init() {}

        var authenticationResponse: AuthenticationResponse?

        func saveAuthenticationResponse(_ response: AuthenticationResponse) {
            authenticationResponse = response

            saveAccessToken(token: response.accessToken)
            saveRefreshToken(token: response.refreshToken)
        }

        func getAccessToken() -> String? {
            return UserDefaults.standard.string(forKey: Token.access)
        }

        func saveAccessToken(token: String?) {
            UserDefaults.standard.set(token, forKey: Token.access)
        }

        func getRefreshToken() -> String? {
            return UserDefaults.standard.string(forKey: Token.refresh)
        }

        func saveRefreshToken(token: String?) {
            UserDefaults.standard.set(token, forKey: Token.refresh)
        }

        func clearSession() {
            authenticationResponse = nil
            UserDefaults.standard.removeObject(forKey: Token.access)
            UserDefaults.standard.removeObject(forKey: Token.refresh)
        }
}


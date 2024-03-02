//
//  UserSessionManager.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 02/03/2024.
//

import Foundation

class UserSessionManager {
    static let shared = UserSessionManager()
    var authenticationResponse: AuthenticationResponse?
    
    private init() {
        self.authenticationResponse = loadAuthenticationResponse()
    }
    
    func saveAuthenticationResponse(_ response: AuthenticationResponse) {
        authenticationResponse = response
        saveUserProfile(account: response.accountResponse)
        saveAccessToken(token: response.accessToken)
        saveRefreshToken(token: response.refreshToken)
    }
    
    func getUserProfile() -> Account? {
        if let userProfileData = UserDefaults.standard.data(forKey: "UserProfileKey") {
            do {
                let userProfile = try JSONDecoder().decode(Account.self, from: userProfileData)
                return userProfile
            } catch {
                print("Error decoding UserProfile: \(error)")
            }
        }
        return nil
    }
    
    func saveUserProfile(account: Account?) {
        do {
            let accountData = try JSONEncoder().encode(account)
            UserDefaults.standard.set(accountData, forKey: "UserProfileKey")
        } catch {
            print("Error encoding UserProfile: \(error)")
        }
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
    
    private func loadAuthenticationResponse() -> AuthenticationResponse? {
        if let accessToken = UserDefaults.standard.string(forKey: Token.access),
           let refreshToken = UserDefaults.standard.string(forKey: Token.refresh) {
            if let userProfileData = UserDefaults.standard.data(forKey: "UserProfileKey") {
                do {
                    let userProfile = try JSONDecoder().decode(Account.self, from: userProfileData)
                    return AuthenticationResponse(accessToken: accessToken, refreshToken: refreshToken, accountResponse: userProfile)
                } catch {
                    print("Error decoding UserProfile: \(error)")
                }
            }
        }
        return nil
    }
    
    func clearSession() {
        authenticationResponse = nil
        UserDefaults.standard.removeObject(forKey: Token.access)
        UserDefaults.standard.removeObject(forKey: Token.refresh)
        UserDefaults.standard.removeObject(forKey: "UserProfileKey")
    }
    
    func isLoggedIn() -> Bool {
        return authenticationResponse != nil
    }
}

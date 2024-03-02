//
//  APIManager.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 01/03/2024.
//

import Foundation
import Alamofire
import Combine

struct APIConstants {
    static let baseURL = "http://localhost:8080/"
    //    static let baseURL = "http://192.168.1.10:8080/"
    //    static let baseURL = "http://172.20.10.2:8080/"
    
    struct Auth {
        static let login = baseURL + "auth/login"
        static let checkEmail = baseURL + "auth/check-email"
        static let createAccount = baseURL + "auth/register"
    }
    
    static let getListStaff = baseURL + "staff/"
    
    static let logout = baseURL + "account/logout"
}

struct APIParameter {
    static let keyword = "keyword"
    static let searchType = "searchType"
    static let sortByColumn = "sortByColumn"
    static let asc = "asc"
}

enum APIError: Error {
    case failedToGetData
    case badUrl
}

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func checkEmailExisted(email: String) -> AnyPublisher<AuthenticationResponse, Error> {
        let url = APIConstants.Auth.checkEmail
        let parameters: [String: Any] = ["email": email]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .publishData()
            .tryMap { response in
                guard let data = response.data else {
                    throw AFError.responseValidationFailed(reason: .dataFileNil)
                }
                do {
                    return try JSONDecoder().decode(AuthenticationResponse.self, from: data)
                } catch {
                    throw error
                }
            }
            .eraseToAnyPublisher()
    }
    
//    func getListStaff() -> AnyPublisher< {
//        
//    }
}


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
    
    func signIn(email: String, password: String, completion: @escaping (Result<AuthenticationResponse, Error>) -> Void) {
        let userSignIn = UserSignIn(email: email, password: password)
        let apiUrl = APIConstants.Auth.login
        
        AF.request(apiUrl, method: .post, parameters: userSignIn, encoder: JSONParameterEncoder.default).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let authenticationResponse = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
                    completion(.success(authenticationResponse))
                } catch let error {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
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
    
    func logout(accessToken: String, completion: @escaping (Result<AuthenticationResponse, Error>) -> Void) {
        let url = APIConstants.logout
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let authenticationResponse = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
                    completion(.success(authenticationResponse))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getListStaff(shopId: Int, accessToken: String, getParameter: GetParameter) -> AnyPublisher<AccountListResponse, Error> {
        guard let url = URL(string: APIConstants.getListStaff + "\(shopId)") else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            APIParameter.asc: getParameter.asc,
            APIParameter.sortByColumn: getParameter.sortByColumn
        ]
        
        return AF.request(url, method: .get, parameters: parameters, headers: headers)
            .publishDecodable(type: AccountListResponse.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
}


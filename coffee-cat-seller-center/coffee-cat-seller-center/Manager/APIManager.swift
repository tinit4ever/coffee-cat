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
        static let areas = baseURL + "auth/areas"
    }
    
    static let getListStaff = baseURL + "staff/"
    static let createStaff = baseURL + "staff/createStaff"
    static let updateStaff = baseURL + "staff/updateStaff"
    
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
    
    func getAreaListByShopId(shopId: Int, date: String) -> AnyPublisher<AreaList, Error> {
            guard let url = URL(string: APIConstants.Auth.areas) else {
                return Fail(error: APIError.badUrl).eraseToAnyPublisher()
            }
            
            let parameters: [String: Any] = [
                "date": date,
                "shopId": shopId
            ]
            
            return AF.request(url, method: .get, parameters: parameters)
                .publishDecodable(type: AreaList.self)
                .value()
                .mapError { error in
                    return error as Error
                }
                .eraseToAnyPublisher()
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
//            "Authorization": "Bearer \(accessToken)",
            "Authorization": "Bearer eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJ0aW5AZ21haWwuY29tIiwiaWF0IjoxNzA5MzY0OTM3LCJleHAiOjE3MDkzNzU3Mzd9.rme7Xq--TFK5MGSXuOf5WtK_w5uURVquWu1lOmC0W8HvrLxK3yFfjWmt1Aj3IiHa",
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
    
    func createStaff(with model: CreateAccountModel, accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.createStaff) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(url, method: .post, parameters: model, encoder: JSONParameterEncoder.default, headers: headers)
            .publishData()
            .tryMap { response in
                guard response.response?.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            .mapError { $0 as Error }
            .map{ _ in }
            .eraseToAnyPublisher()
    }
    
    func updateStaff(with model: CreateAccountModel, accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.updateStaff) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(url, method: .post, parameters: model, encoder: JSONParameterEncoder.default, headers: headers)
            .publishData()
            .tryMap { response in
                guard response.response?.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            .mapError { $0 as Error }
            .map{ _ in }
            .eraseToAnyPublisher()
    }
}

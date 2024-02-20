//
//  APIManager.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation
import Alamofire

struct APIConstants {
    static let baseURL = "http://localhost:8080/"
    
    struct Auth {
        static let login = baseURL + "auth/login"
        static let register = baseURL + "auth/register"
        static let listShop = baseURL + "auth/list-shop"
    }
}

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func fetchShopList(completion: @escaping (Result<ShopList, Error>) -> Void) {
        let url = APIConstants.Auth.listShop
        let parameters: [String: Any] = [
            "asc": true,
            "sortByColumn": "rating"
        ]
        
        AF.request(url, method: .get, parameters: parameters)
            .responseDecodable(of: ShopList.self) { response in
                switch response.result {
                case .success(let shopList):
                    completion(.success(shopList))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func signUp(userRegistration: UserRegistration, completion: @escaping (Result<AuthenticationResponse, Error>) -> Void) {
        AF.request(APIConstants.Auth.register, method: .post, parameters: userRegistration, encoder: JSONParameterEncoder.default).responseData { response in
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
}

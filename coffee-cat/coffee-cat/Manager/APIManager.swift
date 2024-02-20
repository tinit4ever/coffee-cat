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
        
        getListOfShops { result in
            switch result {
            case .success(let apiResponse):
                // Access the data from the apiResponse here
                print(apiResponse)
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
        
        let url = APIConstants.Auth.listShop
        
        let data = ShopListParameters(pageNo: 0, pageSize: 10, sortByColumn: "rating", sort: "ASC")
        
        //        let parameters: [String: Any] = [
        //            "pageNo": 0,
        //            "pageSize": 10,
        //            "sortByColumn": "rating",
        //            "sort": "ASC"
        //        ]
        
        let parameters = data
        
        AF.request(url, method: .get, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let authenticationResponse = try JSONDecoder().decode(ShopList.self, from: data)
                        completion(.success(authenticationResponse))
//                        print(authenticationResponse)
                    } catch let error {
                        completion(.failure(error))
                    }
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
    
    func getListOfShops(completion: @escaping (Result<ApiResponse, Error>) -> Void) {
        let url = "http://localhost:8080/auth/list-shop"
        let parameters: [String: Any] = [
            "pageNo": 0,
            "pageSize": 10,
            "sortByColumn": "rating",
            "sort": "ASC"
        ]

        AF.request(url, method: .get, parameters: parameters)
            .responseDecodable(of: ApiResponse.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    // Handle the API response here
                    print(apiResponse.content)
                    print(apiResponse.pageable)
                    print(apiResponse.totalPages)
                    // Add more handling as needed
                case .failure(let error):
                    // Handle the error
                    print("Error: \(error)")
                }
            }
    }
}

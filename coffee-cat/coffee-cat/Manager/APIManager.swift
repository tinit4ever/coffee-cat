//
//  APIManager.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation
import Alamofire
import Combine

struct APIConstants {
//    static let baseURL = "http://localhost:8080/"
    static let baseURL = "http://192.168.1.10:8080/"
    
    struct Auth {
        static let login = baseURL + "auth/login"
        static let register = baseURL + "auth/register"
        static let listShop = baseURL + "auth/list-shop"
        static let search = baseURL + "auth/search"
    }
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
    
    func fetchShopList(completion: @escaping (Result<ShopList, Error>) -> Void) {
        let url = APIConstants.Auth.listShop
        
        let parameters: [String: Any] = [
            APIParameter.asc: true,
            APIParameter.sortByColumn: "rating"
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
    
    func searchShops(search: String, searchParam: SearchParam) -> AnyPublisher<ShopList, Error> {
        guard let url = URL(string: APIConstants.Auth.search) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let parameters: [String: Any] = [
            APIParameter.keyword: search,
            APIParameter.searchType: searchParam.searchType,
            APIParameter.asc: searchParam.asc,
            APIParameter.sortByColumn: searchParam.sortBy
        ]

        return AF.request(url, method: .get, parameters: parameters)
            .publishDecodable(type: ShopList.self)
            .value()
            .mapError{ error in
                return error as Error
            }
            .eraseToAnyPublisher()
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

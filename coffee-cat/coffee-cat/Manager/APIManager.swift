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
    static let baseURL = "http://192.168.1.25:8080/"
    //    static let baseURL = "http://172.20.10.2:8080/"
    
    struct Auth {
        static let login = baseURL + "auth/login"
        static let checkEmail = baseURL + "auth/check-email"
        static let register = baseURL + "auth/register"
        static let listShop = baseURL + "auth/list-shop"
        static let search = baseURL + "auth/search"
        static let areas = baseURL + "auth/areas"
    }
    
    struct Booking {
        static let create = baseURL + "booking/create"
        static let cancel = baseURL + "booking/cancel"
        static let history = baseURL + "customer/history"
    }
    
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
    
    func getAreaListByShopId(shopId: Int, date: String) -> AnyPublisher<AreaList, Error> {
        guard let url = URL(string: APIConstants.Auth.areas) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let parameters: [String: Any] = [
            "shopId": shopId,
            "date": date
        ]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .publishDecodable(type: AreaList.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func checkEmailExisteda(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = APIConstants.Auth.checkEmail
        let parameters = ["email": email]
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let authenticationResponse = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
                    completion(.success(authenticationResponse.status ?? false))
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
    
    func createBooking(booking: Booking, accessToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = APIConstants.Booking.create
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters = booking
        
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let authenticationResponse = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
                    completion(.success(authenticationResponse.message ?? ""))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cancelBooking(bookingId: Int, accessToken: String) -> AnyPublisher<Bool, Error> {
        let url = APIConstants.Booking.cancel
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters = CancelBookingBody(bookingId: bookingId)
        
        return AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
            .publishData()
            .tryMap { response in
                guard (200...299).contains(response.response?.statusCode ?? 0) else {
                    throw AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: response.response?.statusCode ?? 0))
                }
                return true
            }
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func getBookingHistory(accessToken: String) -> AnyPublisher<BookingResponse, Error> {
        guard let url = URL(string: APIConstants.Booking.history) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(url, method: .get, headers: headers)
            .publishDecodable()
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
}

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
    //    static let baseURL = "http://localhost:8080/"
    static let baseURL = "http://192.168.1.25:8080/"
    //    static let baseURL = "http://172.20.10.2:8080/"
    
    struct Auth {
        static let login = baseURL + "auth/login"
        static let checkEmail = baseURL + "auth/check-email"
        static let createAccount = baseURL + "auth/register"
        static let areas = baseURL + "auth/areas"
    }
    
    struct Owner {
        static let listStaff = baseURL + "owner/staff/list"
        static let createStaff = baseURL + "owner/staff/create"
        static let updateStaff = baseURL + "owner/staff/update"
        static let banStaff = baseURL + "owner/staff/inactive"
        static let unbanStaff = baseURL + "owner/staff/active"
        
        static let createSeat = baseURL + "owner/area/create"
        static let deleteSeats = baseURL + "owner/area/delete"
        
        static let getMenuList = baseURL + "menu/list"
        static let createMenuItem = baseURL + "menu/create"
        static let updateMenuItem = baseURL + "menu/update"
        static let deleteMenuItem = baseURL + "menu/delete"
        
        static let catList = baseURL + "cat/list"
        static let createCat = baseURL + "cat/create"
        static let deleteCats = baseURL + "cat/delete"
        
        static let shopProfile = baseURL + "shop/profile"
        static let updateProfile = baseURL + "owner/shop/update"
    }
    
    struct Admin {
        static let getAccount = baseURL + "account/get-all"
        static let banAccount = baseURL + "account/ban"
        static let unbanAccount = baseURL + "account/unban"
        static let createShop = baseURL + "shop/create"
    }
    
    struct Staff {
        static let listBooking = baseURL + "booking/get"
        static let approveBooking = baseURL + "booking/approve"
        static let rejectBooking = baseURL + "booking/reject"
    }
    
    static let logout = baseURL + "account/logout"
}

struct APIParameter {
    //    static let keyword = "keyword"
    //    static let searchType = "searchType"
    static let sortByColumn = "column"
    static let asc = "ascOrder"
}

enum APIError: Error {
    case failedToGetData
    case nilResponse
    case badUrl
    case statusUnexpected
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
    
    // MARK: - Shop Owner
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
    
    func getListStaff(accessToken: String, getParameter: GetParameter) -> AnyPublisher<AccountListResponse, Error> {
        guard let url = URL(string: APIConstants.Owner.listStaff) else {
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
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .publishDecodable(type: AccountListResponse.self)
            .value()
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func createStaff(with model: CreateAccountModel, accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.Owner.createStaff) else {
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
        guard let url = URL(string: APIConstants.Owner.updateStaff) else {
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
    
    func banStaff(with staffId: Int, accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.Owner.banStaff) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "staffId": staffId
        ]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
    
    func unbanStaff(with staffId: Int, accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.Owner.unbanStaff) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "staffId": staffId
        ]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
    
    func createSeat(with creaAreaModel: CreateAreaModel, accessToken: String) -> AnyPublisher<CreateAreaResponse, Error> {
        guard let url = URL(string: APIConstants.Owner.createSeat) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(url, method: .post, parameters: creaAreaModel, encoder: JSONParameterEncoder.default, headers: headers)
            .publishDecodable(type: CreateAreaResponse.self)
            .tryMap { response in
                guard response.response?.statusCode == 200 else {
                    if let statusCode = response.response?.statusCode {
                        print("Unexpected status code: \(statusCode)")
                    }
                    throw APIError.failedToGetData
                }
                return try response.result.get()
            }
            .eraseToAnyPublisher()
    }
    
    func deleteSeats(with seatIds: [SeatId], accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.Owner.deleteSeats) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let seatListRequest = SeatListRequest(seatList: seatIds)
        
        return AF.request(url, method: .post, parameters: seatListRequest, encoder: JSONParameterEncoder.default, headers: headers)
            .publishData()
            .tryMap { response in
                guard response.response?.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            .mapError { $0 as Error }
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    func getMenuList(_ accessToken: String) -> AnyPublisher<GetMenuResponse, Error> {
        guard let url = URL(string: APIConstants.Owner.getMenuList) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(url, method: .get, headers: headers)
            .publishDecodable(type: GetMenuResponse.self)
            .tryMap { response in
                guard response.response?.statusCode == 200 else {
                    if let statusCode = response.response?.statusCode {
                        print("Unexpected status code: \(statusCode)")
                    }
                    throw APIError.failedToGetData
                }
                return try response.result.get()
            }
            .eraseToAnyPublisher()
    }
    
    func createMenuItem(with item: MenuItem, accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.Owner.createMenuItem) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "id": item.id ?? 0,
            "name": item.name ?? "",
            "price": item.price ?? 0.0,
            "description": ""
        ]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.failedToGetData
                }
                
                guard statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            .mapError({ error in
                return error as Error
            })
            .map { _ in}
            .eraseToAnyPublisher()
    }
    
    func updateMenuItem(with item: MenuItem, accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.Owner.updateMenuItem) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "id": item.id ?? 0,
            "name": item.name ?? "",
            "price": item.price ?? 0.0,
            "description": ""
        ]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.failedToGetData
                }
                
                guard statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            .mapError({ error in
                return error as Error
            })
            .map { _ in}
            .eraseToAnyPublisher()
    }
    
    func deleteMenuItem(with id: Int, accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.Owner.deleteMenuItem) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "itemId": id
        ]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.failedToGetData
                }
                
                guard statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            .mapError({ error in
                return error as Error
            })
            .map { _ in}
            .eraseToAnyPublisher()
    }
    
    func getCatList(_ accessToken: String) -> AnyPublisher<CatListResponse, Error> {
        guard let url = URL(string: APIConstants.Owner.catList) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(url, method: .get, headers: headers)
            .publishDecodable(type: CatListResponse.self)
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.failedToGetData
                }
                
                guard statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return try response.result.get()
            }
            .eraseToAnyPublisher()
    }
    
    func createCat(with model: CatCreateionModel, accessToken: String) -> AnyPublisher<CreateCatResponse, Error> {
        guard let url = URL(string: APIConstants.Owner.createCat) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(url, method: .post, parameters: model, encoder: JSONParameterEncoder.default, headers: headers)
            .publishDecodable(type: CreateCatResponse.self)
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.failedToGetData
                }
                
                guard statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return try response.result.get()
            }
            .eraseToAnyPublisher()
    }
    
    func deleteCats(with catIds: [CatId], accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.Owner.deleteCats) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let catListRequest = CatListRequest(listCatId: catIds)
        
        return AF.request(url, method: .post, parameters: catListRequest, encoder: JSONParameterEncoder.default, headers: headers)
            .publishData()
            .tryMap { response in
                guard response.response?.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            .mapError { $0 as Error }
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    func getShopProfile(accessToken: String) -> AnyPublisher<GetShopProfileResponse, Error> {
        guard let url = URL(string: APIConstants.Owner.shopProfile) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(url, method: .get, headers: headers)
            .publishDecodable(type: GetShopProfileResponse.self)
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.failedToGetData
                }
                
                guard statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return try response.result.get()
            }
            .eraseToAnyPublisher()
    }
    
    func updateShopProfile(with model: ShopUpdateParameter, accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.Owner.updateProfile) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(url, method: .post, parameters: model, encoder: JSONParameterEncoder.default, headers: headers)
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.failedToGetData
                }
                
                guard statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            .mapError({ error in
                return error as Error
            })
            .map { _ in}
            .eraseToAnyPublisher()
    }
    
    // MARK: - Admin
    func getAllAccount(accessToken: String) -> AnyPublisher<GetAllAccountModel, Error> {
        guard let url = URL(string: APIConstants.Admin.getAccount) else {
            return Fail(error: APIError.badUrl)
                .eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(url, method: .get, headers: headers)
            .publishDecodable(type: GetAllAccountModel.self)
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.failedToGetData
                }
                
                guard statusCode == 200 else  {
                    throw URLError(.badServerResponse)
                }
                return try response.result.get()
            }
            .mapError { error in
                return error as Error
            }
            .eraseToAnyPublisher()
    }
    
    func banAccount(with accountId: Int, accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.Admin.banAccount) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "accountId": accountId
        ]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
    
    func unbanAccount(with accountId: Int, accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.Admin.unbanAccount) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "accountId": accountId
        ]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
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
    
    func createShopOwner(with shopCreationModel: ShopCreationModel, accessToken: String) -> AnyPublisher<ShopCreationResponse, Error> {
        //        guard let url = URL(string: APIConstants.Admin.createShop) else {
        //            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        //        }
        
        guard let url = URL(string: "https://189e-14-191-196-47.ngrok-free.app/shop/create") else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        var accessToken1 = "eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJudWxsQG51bGwubnVsbCIsImlhdCI6MTcwOTk1ODEyMywiZXhwIjoxNzEwMzkwMTIzfQ.QDExCACH8vRQ3sSJWQ3XajpvLin7z1IdHsSwnDyubRVhRU7We4W51B2MYsAZNgIZ"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken1)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(url, method: .post, parameters: shopCreationModel, encoder: JSONParameterEncoder.default, headers: headers)
            .publishDecodable(type: ShopCreationResponse.self)
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.failedToGetData
                }
                
                guard statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return try response.result.get()
            }
            .mapError({ error in
                return error as Error
            })
            .eraseToAnyPublisher()
    }
    
    // MARK: - Staff
    func getBookingList(accessToken: String) -> AnyPublisher<BookingResponse, Error> {
        guard let url = URL(string: APIConstants.Staff.listBooking) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(url, method: .get, headers: headers)
            .publishDecodable(type: BookingResponse.self)
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.failedToGetData
                }
                
                guard statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                return try response.result.get()
            }
            .eraseToAnyPublisher()
    }
    
    func approveBooking(bookingId: Int, accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.Staff.approveBooking) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [ "id": bookingId]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.failedToGetData
                }
                
                guard statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            .mapError { error in
                return error as Error
            }
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    func rejectBooking(bookingId: Int, accessToken: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: APIConstants.Staff.rejectBooking) else {
            return Fail(error: APIError.badUrl).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [ "id": bookingId]
        
        return AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw APIError.failedToGetData
                }
                
                guard statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
            }
            .mapError { error in
                return error as Error
            }
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
}

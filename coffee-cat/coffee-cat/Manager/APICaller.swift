//
//  APICaller.swift
//  coffee-cat
//
//  Created by Tin on 01/02/2024.
//

import Foundation

struct Constants {
//    static let baseURL = "https://api.themoviedb.org/"
//    static let apiKey = "api_key=7cefec7107fe486b94e01a96091cee4f"
    static let apiName = "example"
}

enum APIError: Error {
    case failedToGetData
}

class  APICaller {
    static let shared = APICaller()
    var name: String = ""
    private init() {}
    
    func requestAPI<T: Codable>(url: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: Constants.apiName) else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
        
}

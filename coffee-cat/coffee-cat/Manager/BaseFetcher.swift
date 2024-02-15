//
//  BaseFetcher.swift
//  coffee-cat
//
//  Created by Tin on 01/02/2024.
//

import Foundation

struct APIPath {
    static let getTrendingMovie: String = "3/trending/movie/day?"
    static let getGenre: String = "3/genre/movie/list?"
}

class BaseFetcher {
//    func getTrendingMovie(completion: @escaping (Result<[Movie], Error>) -> Void)  {
//        APICaller.shared.requestAPI(url: APIPath.getTrendingMovie, responseType: MovieResponse.self) { result in
//            switch result {
//                case .success(let data):
//                    completion(.success(data.results))
//                case .failure(let error):
//                    completion(.failure(error))
//            }
//        }
//    }
}

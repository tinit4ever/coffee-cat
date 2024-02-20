//
//  Shop.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation

struct ShopList: Codable {
    var content: [Shop]
}

struct Shop: Codable {
    var name: String?
    var address: String?
    var rating: Double?
    var openTime: String?
    var closeTime: String?
    var shopImageList: [String]
    var commentList: [String]
}

struct ShopListParameters: Codable {
    let pageNo: Int
    let pageSize: Int
    let sortByColumn: String
    let sort: String
}
//___________________________________________________________________________________________________________________
struct Store: Codable {
    var rating: Double?
    var name: String
    var shopImageList: [String]
    var avatar: String?
    var followerCount: Int
    var message: String?
    var status: Bool
    var token: String?
}

struct Pageable: Codable {
    var pageNumber: Int
    var pageSize: Int
    var sort: Sort
    var offset: Int
    var paged: Bool
    var unpaged: Bool
}

struct Sort: Codable {
    var empty: Bool
    var unsorted: Bool
    var sorted: Bool
}

struct ApiResponse: Codable {
    var content: [Store]
    var pageable: Pageable
    var totalPages: Int
    var totalElements: Int
    var last: Bool
    var size: Int
    var number: Int
    var sort: Sort
    var numberOfElements: Int
    var first: Bool
    var empty: Bool
}

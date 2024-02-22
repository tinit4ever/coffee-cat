//
//  Shop.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation

struct Shop: Codable {
    var rating: Double?
    var name: String
    var shopImageList: [String]
    var avatar: String?
    var followerCount: Int
    var openTime: String?
    var closeTime: String?
    var address: String?
    var commentList: [String]?
//    var seatList: [String]?
//    var phone: Int?
}

struct ShopList: Codable {
    var shopList: [Shop]
    var status: Bool
    var message: String
}

struct SearchParam {
    var searchType: String
    var sortBy: String
    var asc: Bool
}


//
//  Shop.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation

struct Shop: Codable {
    var id: Int?
    var rating: Double?
    var name: String?
    var shopImageList: [String]
    var avatar: String?
    var address: String?
    var commentList: [String]?
    var phone: String?
    var openTime: String?
    var closeTime: String?
    var areaList: [Area]?
}

struct Area: Codable {
    var name: String?
    var catList: [Cat]?
    var seatList: [Seat]?
}

struct Cat: Codable {
    var id: Int?
    var type: String?
    var description: String
    var imgLink: String?
}

struct Seat: Codable {
    var id : Int?
    var name: String?
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

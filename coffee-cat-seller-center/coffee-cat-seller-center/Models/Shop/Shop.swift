//
//  Shop.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 03/03/2024.
//

import Foundation

struct ShopList: Codable {
    var shopList: [Shop]
    var status: Bool
    var message: String
}

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
    var menuItemList: [MenuItem]?
}

struct MenuItem: Codable {
    var id: Int?
    var name: String?
    var price: Double?
    var imgLink: String?
    var description: String?
    var discount: Double?
    var soldQuantity: Int?
    var status: String?

}

struct SearchParam {
    var searchType: String
    var sortBy: String
    var asc: Bool
}

struct GetMenuResponse: Decodable {
    var status: Bool
    var message: String
    var itemList: [MenuItem]
}

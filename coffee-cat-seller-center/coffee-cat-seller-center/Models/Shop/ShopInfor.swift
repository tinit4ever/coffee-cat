//
//  ShopInfor.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 08/03/2024.
//

import Foundation

struct GetShopProfileResponse: Codable {
    var status: Bool
    var message: String
    var shop: ShopInfor
}

struct ShopInfor: Codable {
    var id: Int
    var name: String
    var address: String
    var openTime: String
    var closeTime: String
    var phone: String
    var avatar: String
}

struct ShopUpdateParameter: Codable {
    var name: String
    var address: String
    var openTime: String
    var closeTime: String
    var phone: String
    var avatar: String = ""
}

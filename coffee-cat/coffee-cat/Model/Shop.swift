//
//  Shop.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation

struct Shop: Codable {
    var name: String?
    var address: String?
    var rating: Double?
    var openTime: String?
    var closeTime: String?
    var shopImageList: [String]
    var commentList: [String]
}

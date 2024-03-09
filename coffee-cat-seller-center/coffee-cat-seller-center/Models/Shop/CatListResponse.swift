//
//  CatListResponse.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 08/03/2024.
//

import Foundation

struct CatListResponse: Codable {
    var status: Bool
    var message: String
    var area: [AreaCat]
}

struct AreaCat: Codable {
    var areaId: Int
    var areaName: String
    var cat: [Cat]
}

struct Cat: Codable {
    var id: Int
    var name: String
    var type: String
    var description: String
    var imgLink: String
}

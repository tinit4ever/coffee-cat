//
//  CreateCatModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 08/03/2024.
//

import Foundation

struct CatCreateionModel: Codable {
    var name: String
    var areaName: String
    var type: String
    var description: String = ""
    var imgLink: String = ""
}

struct CreateCatResponse: Codable {
    var status: Bool
    var message: String
}

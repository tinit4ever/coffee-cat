//
//  ShopCreationModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 07/03/2024.
//

import Foundation


struct ShopCreationModel: Codable {
    var name: String
    var email: String
    var shopEmail: String
    var phone: String
}

struct ShopCreationResponse: Codable {
    var message: String
    var status: Bool
}

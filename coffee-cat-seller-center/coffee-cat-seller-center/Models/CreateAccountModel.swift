//
//  CreateAccountModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 02/03/2024.
//

import Foundation

struct CreateAccountModel: Codable {
    var shopId: Int
    var email: String
    var password: String
    var name: String
}

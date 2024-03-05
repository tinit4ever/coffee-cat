//
//  CreateAreaModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 04/03/2024.
//

import Foundation

struct CreateAreaModel: Codable {
    var id: Int = -1
    var name: String
    var seatName: String
    var seatCapacity: Int
}

struct CreateAreaResponse: Codable {
    var status: Bool
    var message: String
}

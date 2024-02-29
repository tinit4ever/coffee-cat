//
//  BookingResponse.swift
//  coffee-cat
//
//  Created by Tin on 29/02/2024.
//

import Foundation

struct BookingResponse: Codable {
    var message: String?
    var status: Bool?
    var bookingDate: String?
    var bookingList: [BookingDetail]?
}

struct BookingDetail: Codable {
    var bookingID: Int
    var totalPrice: Double
    var bookingDate: String
    var status: String
}


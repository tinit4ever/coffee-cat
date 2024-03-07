//
//  BookingResponse.swift
//  coffee-cat
//
//  Created by Tin on 29/02/2024.
//

import Foundation

enum BookingStatus: String, Codable {
    case pending = "pending"
    case confirmed = "confirmed"
    case cancelled = "cancelled"
}

struct BookingResponse: Codable {
    var message: String?
    var status: Bool?
    var bookingDate: String?
    var bookingList: [BookingDetail]?
}

struct BookingDetail: Codable {
    var bookingId: Int
    var shopName: String?
    var totalPrice: Double
    var bookingDate: String
    var status: BookingStatus
}


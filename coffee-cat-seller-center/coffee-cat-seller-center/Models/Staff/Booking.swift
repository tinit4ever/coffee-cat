//
//  Booking.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 05/03/2024.
//

import Foundation

struct ManagerBookingBody: Codable {
    var bookingId: Int
}

enum BookingStatus: String, Codable {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case cancelled = "Cancelled"
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

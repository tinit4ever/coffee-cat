//
//  Booking.swift
//  coffee-cat
//
//  Created by Tin on 28/02/2024.
//

import Foundation

struct Booking: Codable {
    var seatID: Int
    var bookingDate: String
    var extraContant: String
    var bookingShopMenuRequestList: [MenuBooking]
}

struct MenuBooking: Codable {
    var itemID: Int
    var quantity: Int
}

//
//  Area.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 03/03/2024.
//

import Foundation

struct AreaList: Codable {
    var areaResponseList: [Area]?
    var status: Bool
    var message: String
}

struct Area: Codable {
    var id: Int?
    var name: String?
//    var catList: [Cat]?
    var seatList: [Seat]?
}

//struct Cat: Codable {
//    var id: Int?
//    var type: String?
//    var description: String
//    var imgLink: String?
//}

struct Seat: Codable {
    var id : Int?
    var name: String?
    var status: Bool?
    var capacity: Int?
}

struct SeatListRequest: Codable {
    let seatList: [SeatId]
}

struct SeatId: Codable {
    var id: Int
}

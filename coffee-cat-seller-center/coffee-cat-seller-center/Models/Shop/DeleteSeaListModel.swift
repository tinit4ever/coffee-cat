//
//  DeleteSeaListModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 04/03/2024.
//

import Foundation

struct DeleteSeaListModel: Codable {
    var id: Int
    var seatList: [SeatIdModel]
}

struct SeatIdModel: Codable {
    var id: Int
}

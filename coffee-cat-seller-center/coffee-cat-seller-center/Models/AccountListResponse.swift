//
//  AccountList.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 02/03/2024.
//

import Foundation

struct AccountListResponse: Codable {
    let staffList: [Account]?
    let status: Bool
    let message: String
}

struct GetParameter {
    var sortByColumn: String
    var asc: Bool
}

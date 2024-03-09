//
//  DeleteCatModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 08/03/2024.
//

import Foundation

struct CatId: Codable {
    var catId: Int
}

struct CatListRequest: Codable {
    let listCatId: [CatId]
}

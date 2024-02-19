//
//  ShopDetailsViewModel.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation

protocol ShopDetailsViewModelProtocol {
    var index: Int { get set }
    var shop: Shop {get set}
    
    func swipeLeft()
    func swipeRight()
}

class ShopDetailsViewModel: ShopDetailsViewModelProtocol {
    var index: Int
    var shop: Shop
    
    init() {
        self.index = 0
        self.shop = Shop(name: "", address: "", rating: 0.0, openTime: "", closeTime: "", shopImageList: [], commentList: [])
    }
    
    func swipeLeft() {
        if index < shop.shopImageList.count - 1 {
            index += 1
        }
    }
    
    func swipeRight() {
        if index > 0 {
            index -= 1
        }
    }
}

//
//  ShopDetailsViewModel.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation

protocol ShopDetailsViewModelProtocol {
    var imageList: [String] { get set }
    var index: Int { get set }
    
    func swipeLeft()
    func swipeRight()
}

class ShopDetailsViewModel: ShopDetailsViewModelProtocol {
    var imageList: [String] 
    var index: Int
    
    init() {
        self.imageList = []
        self.index = 0
    }
    
    func swipeLeft() {
        if index < imageList.count - 1 {
            index += 1
        }
    }
    
    func swipeRight() {
        if index > 0 {
            index -= 1
        }
    }
}

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
    
    func updateImage()
    func updateIndexLabel() -> String
    func swipeLeft()
    func swipeRight()
}

class ShopDetailsViewModel: ShopDetailsViewModelProtocol {
    var imageList: [String]
    var index: Int
    
    init(imageList: [String], index: Int) {
        self.imageList = imageList
        self.index = index
    }
    
    func updateImage() {
        // Implement the logic to update the image based on the current index
    }
    
    func updateIndexLabel() -> String {
        let totalElements = imageList.count
        return "\(index + 1)/\(totalElements)"
    }
    
    func swipeLeft() {
        if index < imageList.count - 1 {
            index += 1
        }
        updateImage()
    }
    
    func swipeRight() {
        if index > 0 {
            index -= 1
        }
        updateImage()
    }
}

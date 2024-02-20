//
//  HomeViewModel.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation

protocol HomeViewModelProtocol {
    var shopList: ShopList? {get set}
    func getShopList()
}

class HomeViewModel: HomeViewModelProtocol {
    var shopList: ShopList?
    
    func getShopList() {
        APIManager.shared.fetchShopList { result in
            switch result {
            case .success(let shopList):
//                self.shopList = shopList
                print("S")
            case .failure(let error):
                print("E")
            }
        }
    }
    
}

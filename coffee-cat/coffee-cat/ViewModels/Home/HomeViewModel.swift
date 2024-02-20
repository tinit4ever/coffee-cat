//
//  HomeViewModel.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation

protocol HomeViewModelProtocol {
    var shopList: [Shop] {get set}
    func getShopList(completion: @escaping () -> Void)
}

class HomeViewModel: HomeViewModelProtocol {
    var shopList: [Shop] = []
    
    func getShopList(completion: @escaping () -> Void) {
        APIManager.shared.fetchShopList { result in
            switch result {
            case .success(let shopList):
                self.shopList = shopList.shopList
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
}

//
//  ShopManagerViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 08/03/2024.
//

import Foundation
import Combine

protocol ShopManagerViewModelProtocol {
    var shopInfor: ShopInfor? {get set}
    
    var isGetShopInforSuccessSubject: PassthroughSubject<Result<Void, Error>, Never> {get set}
    
    func getShopInfor()
}

class ShopManagerViewModel: ShopManagerViewModelProtocol {
    var shopInfor: ShopInfor?
    
    var isGetShopInforSuccessSubject = PassthroughSubject<Result<Void, Error>, Never>()
    
    var cancellables: Set<AnyCancellable> = []
    
    func getShopInfor() {
        guard let accessToken = UserSessionManager.shared.getAccessToken() else {
            return
        }
        
        APIManager.shared.getShopProfile(accessToken: accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isGetShopInforSuccessSubject.send(.failure(error))
                }
            } receiveValue: { getShopProfileResponse in
                self.shopInfor = getShopProfileResponse.shop
                self.isGetShopInforSuccessSubject.send(.success(()))
            }
            .store(in: &cancellables)
    }
}

//
//  EditShopDetailsViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 08/03/2024.
//

import Foundation
import Combine

protocol EditShopDetailsViewModelProtocol {
    var shopUpdateParameter: ShopUpdateParameter? {get set}
    
    var isUpdatedSubject: PassthroughSubject<Result<Void, Error>, Never> {get set}
    
    func setShopUpdateParameter(name: String, phone: String, address: String, openTime: String, closeTime: String)
    
    func updateShopProfile()
}

class EditShopDetailsViewModel: EditShopDetailsViewModelProtocol {
    var shopUpdateParameter: ShopUpdateParameter?
    
    var isUpdatedSubject = PassthroughSubject<Result<Void, Error>, Never>()
    
    var cancellables: Set<AnyCancellable> = []
    
    func setShopUpdateParameter(name: String, phone: String, address: String, openTime: String, closeTime: String) {
        self.shopUpdateParameter = ShopUpdateParameter(name: name, address: address, openTime: openTime, closeTime: closeTime, phone: phone)
    }
    
    func updateShopProfile() {
        guard let accessToken = UserSessionManager.shared.getAccessToken(),
              let shopUpdateParameter = self.shopUpdateParameter
        else {
            return
        }
        
        APIManager.shared.updateShopProfile(with: shopUpdateParameter, accessToken: accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isUpdatedSubject.send(.failure(error))
                }
            } receiveValue: { _ in
                self.isUpdatedSubject.send(.success(()))
            }
            .store(in: &cancellables)
    }
}

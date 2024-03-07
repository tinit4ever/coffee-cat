//
//  ShopCreationInputViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 07/03/2024.
//

import Foundation
import Combine

protocol ShopCreationInputViewModelProtocol {
    var shopCreationModel: ShopCreationModel? {get set}
    var isCreatedShopSubject: PassthroughSubject<Result<String, Error>, Never> {get set}
    
    func createShop()
    
    func setShopCreationModel(shopCreationModel: ShopCreationModel)
}

class ShopCreationInputViewModel: ShopCreationInputViewModelProtocol {
    var shopCreationModel: ShopCreationModel?
    
    var isCreatedShopSubject = PassthroughSubject<Result<String, Error>, Never>()
    
    // MARK: - local variable
    var cancellables: Set<AnyCancellable> = []
    
    func createShop() {
        guard let accessToken = UserSessionManager.shared.getAccessToken(),
              let shopCreationModel = self.shopCreationModel else {
            return
        }
        
        APIManager.shared.createShopOwner(with: shopCreationModel, accessToken: accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { response in
                let status = response.status
                if status {
                    self.isCreatedShopSubject.send(.success(response.message))
                } else {
                    self.isCreatedShopSubject.send(.failure(response.message as! Error))
                }
            }
            .store(in: &cancellables)
    }
    
    func setShopCreationModel(shopCreationModel: ShopCreationModel) {
        self.shopCreationModel = shopCreationModel
    }
}

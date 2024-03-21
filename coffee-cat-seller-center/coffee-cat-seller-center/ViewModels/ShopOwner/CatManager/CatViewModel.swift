//
//  CatViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 03/03/2024.
//

import Foundation
import Combine

protocol CatViewModelProtocol {
    var areaList: [AreaCat] {get set}
    
    var selectedCat: [CatId] {get set}
    
    var isGetDataSubject: PassthroughSubject<Result<Void, Error>, Never> {get set}
    var isDeleteResponseSubject: PassthroughSubject<Result<Void, Error>, Never> {get set}
    
    func getCatList()
    
    func deleteCats()
}

class CatViewModel: CatViewModelProtocol {
    var areaList: [AreaCat] = []
    
    var selectedCat: [CatId] = []
    
    var isGetDataSubject = PassthroughSubject<Result<Void, Error>, Never>()
    var isDeleteResponseSubject = PassthroughSubject<Result<Void, Error>, Never>()
    
    // MARK: - Local variable
    var cancellables: Set<AnyCancellable> = []
    
    func getCatList() {
        guard let accessToken = UserSessionManager.shared.getAccessToken() else {
            return
        }
        
        APIManager.shared.getCatList(accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isGetDataSubject.send(.failure(error))
                }
            } receiveValue: { catListResponse in
                self.areaList = catListResponse.area
                self.isGetDataSubject.send(.success(()))
            }
            .store(in: &cancellables)
    }
    
    func deleteCats() {
        guard let accessToken = UserSessionManager.shared.getAccessToken() else {
            return
        }
        APIManager.shared.deleteCats(with: self.selectedCat, accessToken: accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isDeleteResponseSubject.send(.failure(error))
                }
            } receiveValue: { _ in
                self.isDeleteResponseSubject.send(.success(()))
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

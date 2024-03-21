//
//  MenuViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 06/03/2024.
//

import Foundation
import Combine

protocol MenuViewModelProtocol {
    var menu: [MenuItem] {get set}
    var selectedMenuItem: MenuItem? {get set}
    var submitItem: MenuItem? {get set}
    var isUpdating: Bool {get set}
    var isGetDataPublisher: PassthroughSubject<Result<Void, Error>, Never> {get set}
    var isDeleteSuccessPublisher: PassthroughSubject<Result<Void, Error>, Never> {get set}
    var isCreatedPublisher: PassthroughSubject<Result<Void, Error>, Never> {get set}
    var isUpdatedPublisher: PassthroughSubject<Result<Void, Error>, Never> {get set}
    
    func setSelected(index: Int)
    
    func setSumitItem(id: Int, name: String, price: Double)
    
    func getMenuList()

    func createMenuItem()
    
    func updateMenuItem()
    
    func deleteMenuItem()
}

class MenuViewModel: MenuViewModelProtocol {

    var menu: [MenuItem] = []
    
    var selectedMenuItem: MenuItem?
    
    var submitItem: MenuItem?
    
    var isUpdating: Bool = false
    
    var isGetDataPublisher = PassthroughSubject<Result<Void, Error>, Never>()
    var isDeleteSuccessPublisher = PassthroughSubject<Result<Void, Error>, Never>()
    var isCreatedPublisher = PassthroughSubject<Result<Void, Error>, Never>()
    var isUpdatedPublisher = PassthroughSubject<Result<Void, Error>, Never>()
    
    var cancellables: Set<AnyCancellable> = []
    
    func setSelected(index: Int) {
        self.selectedMenuItem = self.menu[index]
    }
    
    func setSumitItem(id: Int, name: String, price: Double) {
        self.submitItem = MenuItem(id: id, name: name, price: price)
    }
    
    func getMenuList() {
        guard let accessToken = UserSessionManager.shared.getAccessToken() else {
            return
        }
        
        APIManager.shared.getMenuList(accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isGetDataPublisher.send(.failure(error))
                }
            } receiveValue: { getMenuResponse in
                self.menu = getMenuResponse.itemList
                self.isGetDataPublisher.send(.success(()))
            }
            .store(in: &cancellables)
    }
    
    func createMenuItem() {
        guard let accessToken = UserSessionManager.shared.getAccessToken(),
              let item = self.submitItem else {
            return
        }
        APIManager.shared.createMenuItem(with: item, accessToken: accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isCreatedPublisher.send(.failure(error))
                }
            } receiveValue: { _ in
                self.isCreatedPublisher.send(.success(()))
                self.getMenuList()
            }
            .store(in: &cancellables)
    }
    
    func updateMenuItem() {
        guard let accessToken = UserSessionManager.shared.getAccessToken(),
              let item = self.submitItem else {
            return
        }
        
        APIManager.shared.updateMenuItem(with: item, accessToken: accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isUpdatedPublisher.send(.failure(error))
                }
            } receiveValue: { _ in
                self.isUpdatedPublisher.send(.success(()))
                self.getMenuList()
            }
            .store(in: &cancellables)
    }
    
    func deleteMenuItem() {
        guard let accessToken = UserSessionManager.shared.getAccessToken(),
              let id = self.selectedMenuItem?.id else {
            return
        }
        
        APIManager.shared.deleteMenuItem(with: id, accessToken: accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isDeleteSuccessPublisher.send(.failure(error))
                }
            } receiveValue: { _ in
                self.isDeleteSuccessPublisher.send(.success(()))
                self.getMenuList()
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

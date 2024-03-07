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
    var isUpdating: Bool {get set}
    var isGetDataPublisher: PassthroughSubject<Result<Void, Error>, Never> {get set}
    
    func setSelected(index: Int)
    
    func getMenuList()
    
    func createMenuItem()
    
    func updateMenuItem()
    
    func deleteMenuItem()
}

class MenuViewModel: MenuViewModelProtocol {
    var menu: [MenuItem] = []
    
    var selectedMenuItem: MenuItem?
    
    var isUpdating: Bool = false
    
    var isGetDataPublisher = PassthroughSubject<Result<Void, Error>, Never>()
    
    var cancellables: Set<AnyCancellable> = []
    
    func setSelected(index: Int) {
        self.selectedMenuItem = self.menu[index]
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
        
    }
    
    func updateMenuItem() {
        
    }
    
    func deleteMenuItem() {
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

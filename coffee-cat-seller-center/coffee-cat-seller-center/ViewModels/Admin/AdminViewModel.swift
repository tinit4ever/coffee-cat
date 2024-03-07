//
//  AdminViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 07/03/2024.
//

import Foundation
import Combine

protocol AdminViewModelProtocol {
    var accountList: [Account] {get set}
    
    var attachObjectId: Int {get set}
    
    var isGetAccountSubject: PassthroughSubject<Result<Void, Error>, Never> {get set}
    var isChangeStatusSubject: PassthroughSubject<Result<Void, Error>, Never> {get}
    
    func getAllAccont()
    
    func banAccount()
    
    func unbanAccount()
}

class AdminViewModel: AdminViewModelProtocol {
    var accountList: [Account] = []
    
    var attachObjectId: Int = 0
    
    var isGetAccountSubject = PassthroughSubject<Result<Void, Error>, Never>()
    
    var isChangeStatusSubject = PassthroughSubject<Result<Void, Error>, Never>()
    
    
    // MARK: - Local variable
    var cancellables: Set<AnyCancellable> = []
    
    func getAllAccont() {
        guard let accessToken = UserSessionManager.shared.getAccessToken() else {
            return
        }
        
        APIManager.shared.getAllAccount(accessToken: accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isGetAccountSubject.send(.failure(error))
                }
            } receiveValue: { getAllAccountModel in
                self.accountList = getAllAccountModel.accountResponseList
                self.isGetAccountSubject.send(.success(()))
            }
            .store(in: &cancellables)
    }
    
    func banAccount() {
        guard let accessToken = UserSessionManager.shared.getAccessToken() else {
            return
        }
        
        return APIManager.shared.banAccount(with: attachObjectId, accessToken: accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                        break
                case .failure(let error):
                    self.isChangeStatusSubject.send(.failure(error))
                }
            } receiveValue: {
                self.isChangeStatusSubject.send(.success(()))
            }
            .store(in: &cancellables)
    }
    
    func unbanAccount() {
        guard let accessToken = UserSessionManager.shared.getAccessToken() else {
            return
        }
        return APIManager.shared.unbanAccount(with: attachObjectId, accessToken: accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                        break
                case .failure(let error):
                    self.isChangeStatusSubject.send(.failure(error))
                }
            } receiveValue: {
                self.isChangeStatusSubject.send(.success(()))
            }
            .store(in: &cancellables)
    }
}

//
//  StaffAccountViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 01/03/2024.
//

import Foundation
import Combine

protocol StaffAccountViewModelProtocol {
    var staffList: [Account] {get}
    var isChangeStatusSubject: PassthroughSubject<Result<Void, Error>, Never> {get}
    
    func getListOfStaff(accessToken: String, getParameter: GetParameter, onSuccess: @escaping () -> Void)
    func banStaff(staffId: Int, accessToken: String)
    func unbanStaff(staffId: Int, accessToken: String)
}

class StaffAccountViewModel: StaffAccountViewModelProtocol {
    @Published var staffList: [Account] = []
    var cancellables: Set<AnyCancellable> = []
    var isChangeStatusSubject = PassthroughSubject<Result<Void, Error>, Never>()
    
    func getListOfStaff(accessToken: String, getParameter: GetParameter, onSuccess: @escaping () -> Void) {
        APIManager.shared.getListStaff(accessToken: accessToken, getParameter: getParameter)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching staff list: \(error)")
                }
            }, receiveValue: { [weak self] staffListResponse in
                if let staffList = staffListResponse.staffList {
                    self?.staffList = staffList
                }
                print("Received Staff List: \(staffListResponse)")
                onSuccess()
            })
            .store(in: &cancellables)
    }
    
    func banStaff(staffId: Int, accessToken: String) {
        return APIManager.shared.banStaff(with: staffId, accessToken: accessToken)
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
    
    func unbanStaff(staffId: Int, accessToken: String) {
        return APIManager.shared.unbanStaff(with: staffId, accessToken: accessToken)
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
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

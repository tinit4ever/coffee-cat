//
//  InputAreaViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 04/03/2024.
//

import Foundation
import Combine

enum DataEror: Error {
    case areaNameIsExisted
    case tableNameIsExisted
}

protocol InputAreaViewModelProtocol {
    var areaList: [Area] {get set}
    var seatSubmition: CreateAreaModel? {get set}
    var accessToken: String {get}
    var createCompletionRequest: PassthroughSubject<Result<String, Error>, Never> {get}
    
    func createSeat()
}

class InputAreaViewModel: InputAreaViewModelProtocol {
    var areaList: [Area] = []
    var accessToken: String
    var cancellables: Set<AnyCancellable> = []
    @Published var createCompletionRequest = PassthroughSubject<Result<String, Error>, Never>()
    var seatSubmition: CreateAreaModel?
    
    init() {
        self.seatSubmition = CreateAreaModel(id: 1, name: "", seatName: "", seatCapacity: 1)
        self.accessToken = UserSessionManager.shared.getAccessToken() ?? ""
    }
    
    func createSeat() {
        guard let createAreaModel = self.seatSubmition else {
            return
        }
        APIManager.shared.createSeat(with: createAreaModel, accessToken: self.accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)" )
                    self.createCompletionRequest.send(.failure(error))
                }
            } receiveValue: { createAreaResponse in
                print(createAreaModel)
                if createAreaResponse.status {
                    self.createCompletionRequest.send(.success("Create sucess"))
                } else {
//                    let errorMessage = createAreaResponse.message
//                    self.createCompletionRequest.send(.failure(errorMessage as! Error))
                }
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

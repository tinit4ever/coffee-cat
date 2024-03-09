//
//  InputCatViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 08/03/2024.
//

import Foundation
import Combine

enum ResponseError: Error {
    case createFail(String)
    
    var localizedDescription: String {
        switch self {
        case .createFail(let message):
            return "Creation failed: \(message)"
        }
    }
}
protocol InputCatViewModelProtocol {
    var areaList: [AreaCat] {get set}
    var selectedAreaName: String? {get set}
    var catSubmition: CatCreateionModel? {get set}
    var isCreateCompletionRequest: PassthroughSubject<Result<String, Error>, Never> {get}
    
    func setCatSubmition(name: String, type: String)
    func createCat()
}

class InputCatViewModel: InputCatViewModelProtocol {
    var areaList: [AreaCat] = []
    var selectedAreaName: String?
    var cancellables: Set<AnyCancellable> = []
    var isCreateCompletionRequest = PassthroughSubject<Result<String, Error>, Never>()
    var catSubmition: CatCreateionModel?

    func setCatSubmition(name: String, type: String) {
        guard let areaName = self.selectedAreaName else {
            return
        }
        self.catSubmition = CatCreateionModel(name: name, areaName: areaName, type: type)
    }

    func createCat() {
        guard let catCreateionModel = self.catSubmition,
              let accessToken = UserSessionManager.shared.getAccessToken()
        else {
            return
        }
        APIManager.shared.createCat(with: catCreateionModel, accessToken: accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)" )
                    self.isCreateCompletionRequest.send(.failure(error))
                }
            } receiveValue: { creaCatResponse in
                if creaCatResponse.status {
                    self.isCreateCompletionRequest.send(.success("Create sucess"))
                } else {
                    let errorMessage = creaCatResponse.message
                    self.isCreateCompletionRequest.send(.failure(ResponseError.createFail(errorMessage)))
                }
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

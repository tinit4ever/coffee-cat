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
    func getListOfStaff(shopId: Int, accessToken: String, getParameter: GetParameter)
}

class StaffAccountViewModel: StaffAccountViewModelProtocol {
    @Published var staffList: [Account] = []
    var cancellables: Set<AnyCancellable> = []
    
    func getListOfStaff(shopId: Int, accessToken: String, getParameter: GetParameter) {
        APIManager.shared.getListStaff(shopId: 20, accessToken: accessToken, getParameter: getParameter)
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
            })
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

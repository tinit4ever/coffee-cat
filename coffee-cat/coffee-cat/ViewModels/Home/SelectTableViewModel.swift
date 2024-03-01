//
//  SelectTableViewModel.swift
//  coffee-cat
//
//  Created by Tin on 29/02/2024.
//

import Foundation
import Combine

protocol SelectTableViewModelProtocol {
    var shopId: Int {get set}
    var date: String? {get set}
    var areaList: [Area]? {get set}
    var submitSeat: Seat? {get set}
    var submitDate: String? {get set}
    var dataUpdatedPublisher: PassthroughSubject<Void, Never> {get set}
    func setAreasParam(shopId: Int, date: String)
}

class SelectTableViewModel: SelectTableViewModelProtocol {
    
    var shopId: Int
    
    var date: String?
    
    var areaList: [Area]?
    
    var submitSeat: Seat?
    
    var submitDate: String?
    
    var dataUpdatedPublisher = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    private var getAreasSubject = CurrentValueSubject<(Int, String), Never>((0, ""))
    
    init() {
        self.shopId = 1
        setupAreasPublisher()
    }
    
    func setAreasParam(shopId: Int, date: String) {
        getAreasSubject.send((shopId, date))
    }
    
    func setupAreasPublisher() {
        getAreasSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shopId, date in
                self?.getAreas(shopId: shopId, date: date)
            }
            .store(in: &cancellables)
    }
    
    func getAreas(shopId: Int, date: String) {
        APIManager.shared.getAreaListByShopId(shopId: shopId, date: date)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] areaList in
                self?.areaList = areaList.areaResponseList
                self?.dataUpdatedPublisher.send()
                print(areaList)
            }
            .store(in: &cancellables)
    }
}

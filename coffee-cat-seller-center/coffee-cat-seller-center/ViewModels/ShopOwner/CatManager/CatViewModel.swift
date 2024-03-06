//
//  CatViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 03/03/2024.
//

import Foundation
import Combine

protocol CatViewModelProtocol {
    var date: String? {get set}
    var areaList: [Area]? {get set}
    var dataUpdatedPublisher: PassthroughSubject<Void, Never> {get set}
    func setAreasParam(shopId: Int, date: String)
}

class CatViewModel: CatViewModelProtocol {
    var date: String?
    
    var areaList: [Area]?
    
    var dataUpdatedPublisher = PassthroughSubject<Void, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    private var getAreasSubject = CurrentValueSubject<(Int, String), Never>((0, ""))
    
    init() {
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

//
//  ShopDetailsViewModel.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation
import Combine

protocol ShopDetailsViewModelProtocol {
    var index: Int { get set }
    var shop: Shop? {get set}
    var areaList: [Area]? {get set}
    var booking: Booking? {get set}
    func setAreasParam(shopId: Int, date: String)
    
    func swipeLeft()
    func swipeRight()
}

class ShopDetailsViewModel: ShopDetailsViewModelProtocol {
    var index: Int
    var shop: Shop?
    var areaList: [Area]?
    var booking: Booking?
    
    private var cancellables: Set<AnyCancellable> = []
    private var getAreasSubject = CurrentValueSubject<(Int, String), Never>((0, ""))
    
    init() {
        self.index = 0
        setupAreasPublisher()
    }
    
    func swipeLeft() {
        if index < (shop?.shopImageList.count ?? 0) - 1 {
            index += 1
        }
    }
    
    func swipeRight() {
        if index > 0 {
            index -= 1
        }
    }
    
    func setAreasParam(shopId: Int, date: String) {
        getAreasSubject.send((shopId, date))
    }
    
    func setupAreasPublisher() {
        getAreasSubject
            .sink { [weak self] shopId, date in
                self?.getAreas(shopId: shopId, date: date)
            }
            .store(in: &cancellables)
    }
    
    func getAreas(shopId: Int, date: String) {
        
        let c1 = Cat(id: 1, type: "1", description: "1", imgLink: "")
        let c2 = Cat(id: 2, type: "2", description: "2", imgLink: "")
        let c3 = Cat(id: 3, type: "3", description: "3", imgLink: "")
        let c4 = Cat(id: 4, type: "4", description: "4", imgLink: "")
        let c5 = Cat(id: 5, type: "5", description: "5", imgLink: "")
        let c6 = Cat(id: 6, type: "6", description: "6", imgLink: "")
        let c7 = Cat(id: 7, type: "7", description: "7", imgLink: "")
        let c8 = Cat(id: 8, type: "8", description: "8", imgLink: "")
        let c9 = Cat(id: 9, type: "9", description: "9", imgLink: "")
        
        let a1 = Area(name: "F1", catList: [c1, c2, c3], seatList: [])
        let a2 = Area(name: "F2", catList: [c4, c5, c6], seatList: [])
        let a3 = Area(name: "F3", catList: [c7, c8, c9], seatList: [])
        
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
                print(areaList)
                self?.areaList = [a1, a2, a3]
            }
            .store(in: &cancellables)
    }
}

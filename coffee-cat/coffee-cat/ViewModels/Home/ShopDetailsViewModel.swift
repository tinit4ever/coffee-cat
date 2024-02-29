//
//  ShopDetailsViewModel.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation

protocol ShopDetailsViewModelProtocol {
    var index: Int { get set }
<<<<<<< Updated upstream
    var shop: Shop {get set}
=======
    var shop: Shop? {get set}
    var areaList: [Area]? {get set}
    var booking: Booking {get set}
    func setAreasParam(shopId: Int, date: String)
>>>>>>> Stashed changes
    
    func swipeLeft()
    func swipeRight()
}

class ShopDetailsViewModel: ShopDetailsViewModelProtocol {
    var index: Int
<<<<<<< Updated upstream
    var shop: Shop
    
    init() {
        self.index = 0
        self.shop = Shop(rating: 0.0, name: "", shopImageList: [], commentList: [])
=======
    var shop: Shop?
    var areaList: [Area]?
    var booking: Booking
    
    private var cancellables: Set<AnyCancellable> = []
    private var getAreasSubject = CurrentValueSubject<(Int, String), Never>((0, ""))
    
    init() {
        self.index = 0
        self.booking = Booking(seatID: nil, bookingDate: nil, extraContant: nil, bookingShopMenuRequestList: nil)
        setupAreasPublisher()
>>>>>>> Stashed changes
    }
    
    func swipeLeft() {
        if index < shop.shopImageList.count - 1 {
            index += 1
        }
    }
    
    func swipeRight() {
        if index > 0 {
            index -= 1
        }
    }
<<<<<<< Updated upstream
=======
    
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
            }
            .store(in: &cancellables)
    }
>>>>>>> Stashed changes
}

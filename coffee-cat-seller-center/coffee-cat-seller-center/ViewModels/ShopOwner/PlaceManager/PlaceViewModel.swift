//
//  PlaceViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 03/03/2024.
//

import Foundation
import Combine

protocol PlaceViewModelProtocol {
    var date: String? {get set}
    var areaList: [Area]? {get set}
    var seatCreation: CreateAreaModel? {get set}
    var dataUpdatedPublisher: PassthroughSubject<Void, Never> {get set}
    var deleteResponsePublisher: PassthroughSubject<Result<Void, Error>, Never> {get set}
    var selectedSeat: [SeatId]? {get set}
    func setAreasParam(shopId: Int, date: String)
    func deleteSeats()
}

class PlaceViewModel: PlaceViewModelProtocol {
    var date: String?
    
    var seatCreation: CreateAreaModel?
    
    var areaList: [Area]?
    
    var selectedSeat: [SeatId]?
    
    var dataUpdatedPublisher = PassthroughSubject<Void, Never>()
    var deleteResponsePublisher = PassthroughSubject<Result<Void, Error>, Never>()
    
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
    
    func deleteSeats() {
        if let seatIds = self.selectedSeat,
           let accessToken = UserSessionManager.shared.getAccessToken() {
            APIManager.shared.deleteSeats(with: seatIds, accessToken: accessToken)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.deleteResponsePublisher.send(.failure(error))
                    }
                } receiveValue: { _ in
                    self.deleteResponsePublisher.send(.success(()))
                }
                .store(in: &cancellables)
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

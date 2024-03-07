//
//  BookingManagerViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 07/03/2024.
//

import Foundation
import Combine

protocol BookingManagerViewModelProtocol {
    
    var pendingList: [BookingDetail] {get set}
    
    var confirmedList: [BookingDetail] {get set}
    
    var cancelledList: [BookingDetail] {get set}
    
    var currentList: [BookingDetail] {get set}
    
    var isGetDataCompletedSubject: PassthroughSubject<Result<Void, Error>, Never> {get set}
    
    func getBookingList()
    
    func updateCurrentList(currentStatus: BookingStatus)
}

class BookingManagerViewModel: BookingManagerViewModelProtocol {
    var pendingList: [BookingDetail] = []
    
    var confirmedList: [BookingDetail] = []
    
    var cancelledList: [BookingDetail] = []
    
    var currentList: [BookingDetail] = []
    
    var isGetDataCompletedSubject = PassthroughSubject<Result<Void, Error>, Never>()
    
    // MARK: - Local Variables
    var cancellables: Set<AnyCancellable> = []
    
    func getBookingList() {
        guard let accessToken = UserSessionManager.shared.getAccessToken() else {
            return
        }
        APIManager.shared.getBookingList(accessToken: accessToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isGetDataCompletedSubject.send(.failure(error))
                }
            } receiveValue: { bookingResponse in
                guard let bookingList = bookingResponse.bookingList else {
                    return
                }
                
                self.setupData(bookingHistories: bookingList)
                self.isGetDataCompletedSubject.send(.success(()))
            }
            .store(in: &cancellables)
    }
    
    func updateCurrentList(currentStatus: BookingStatus) {
        switch currentStatus {
        case .pending:
            self.currentList = self.pendingList
        case .confirmed:
            self.currentList = self.confirmedList
        case .cancelled:
            self.currentList = self.cancelledList
        }
    }
    
    private func setupData(bookingHistories: [BookingDetail]) {
        self.pendingList = []
        self.confirmedList = []
        self.cancelledList = []
        for bookingHistory in bookingHistories {
            switch bookingHistory.status {
            case .pending:
                self.pendingList.append(bookingHistory)
            case .confirmed:
                self.confirmedList.append(bookingHistory)
            case .cancelled:
                self.cancelledList.append(bookingHistory)
            }
        }
        
        self.currentList = pendingList
    }
    
}

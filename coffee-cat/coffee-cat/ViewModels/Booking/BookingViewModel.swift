//
//  BookingViewModel.swift
//  coffee-cat
//
//  Created by Tin on 29/02/2024.
//

import Foundation
import Combine

protocol BookingViewModelProtocol {
    var pendingList: [BookingDetail]? {get set}
    var confirmedList: [BookingDetail]? {get set}
    var cancelledList: [BookingDetail]? {get set}
    
    var currentList: [BookingDetail]? {get set}
    
    var bookingHistories: [BookingDetail]? {get set}
    
    func getBookingHistories(accessToken: String, onReceived: @escaping () -> Void)
    
    func updateCurrentList(currentStatus: BookingStatus)
    
    func cancelBooking(bookingID: Int, accessToken: String) -> AnyPublisher<Bool, Error>
}

class BookingViewModel: BookingViewModelProtocol {
    var pendingList: [BookingDetail]?
    
    var confirmedList: [BookingDetail]?
    
    var cancelledList: [BookingDetail]?
    
    var currentList: [BookingDetail]?
    
    var bookingHistories: [BookingDetail]?
    
    var cancellables: Set<AnyCancellable> = []
    
    func getBookingHistories(accessToken: String, onReceived: @escaping () -> Void) {
        APIManager.shared.getBookingHistory(accessToken: accessToken)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { bookingResponse in
                if let bookingList = bookingResponse.bookingList {
                    self.setupData(bookingHistories: bookingList)
                    onReceived()
                }
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
                self.pendingList?.append(bookingHistory)
            case .confirmed:
                self.confirmedList?.append(bookingHistory)
            case .cancelled:
                self.cancelledList?.append(bookingHistory)
            }
        }
        
        self.currentList = pendingList
    }
    
    func cancelBooking(bookingID: Int, accessToken: String) -> AnyPublisher<Bool, Error> {
        return APIManager.shared.cancelBooking(bookingID: bookingID, accessToken: accessToken)
    }
}

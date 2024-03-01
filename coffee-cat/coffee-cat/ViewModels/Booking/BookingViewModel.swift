//
//  BookingViewModel.swift
//  coffee-cat
//
//  Created by Tin on 29/02/2024.
//

import Foundation
import Combine

protocol BookingViewModelProtocol {
    var bookingHistories: [BookingDetail]? {get set}
    func getBookingHistories(accessToken: String, onReceived: @escaping () -> Void)
}

class BookingViewModel: BookingViewModelProtocol {
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
                self.bookingHistories = bookingResponse.bookingList
                onReceived()
            }
            .store(in: &cancellables)
    }
}

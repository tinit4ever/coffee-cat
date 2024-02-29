//
//  SelectTableViewModel.swift
//  coffee-cat
//
//  Created by Tin on 29/02/2024.
//

import Foundation

protocol SelectTableViewModelProtocol {
    var date: String? {get set}
    var areaList: [Area]? {get set}
    var submitSeat: Seat? {get set}
    var submitDate: String? {get set}
}

class SelectTableViewModel: SelectTableViewModelProtocol {
    var date: String?
    
    var areaList: [Area]?
    
    var submitSeat: Seat?
    
    var submitDate: String?
}

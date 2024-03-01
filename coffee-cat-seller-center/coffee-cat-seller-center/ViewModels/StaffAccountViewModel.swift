//
//  StaffAccountViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 01/03/2024.
//

import Foundation

protocol StaffAccountViewModelProtocol {
    var staffList: [Account] {get set}
    
}

class StaffAccountViewModel: StaffAccountViewModelProtocol {
    var staffList: [Account] = []
}

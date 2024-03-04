//
//  InputAreaViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 04/03/2024.
//

import Foundation


protocol InputAreaViewModelProtocol {
    var areaList: [Area] {get set}
    var seatSubmition: CreateAreaModel? {get set}
}

class InputAreaViewModel: InputAreaViewModelProtocol {
    var areaList: [Area] = []
    
    var seatSubmition: CreateAreaModel?
}

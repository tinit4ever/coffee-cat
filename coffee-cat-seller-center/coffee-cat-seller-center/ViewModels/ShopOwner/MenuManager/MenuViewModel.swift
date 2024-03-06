//
//  MenuViewModel.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 06/03/2024.
//

import Foundation

protocol MenuViewModelProtocol {
    var menu: [MenuItem]? {get set}
    var selectedMenuItem: MenuItem? {get set}
    var isUpdating: Bool {get set}
    
    func setSelected(index: Int)
    
    func createMenuItem()
    
    func updateMenuItem()
}

class MenuViewModel: MenuViewModelProtocol {
    var menu: [MenuItem]?
    
    var selectedMenuItem: MenuItem?
    
    var isUpdating: Bool = false
    
    func setSelected(index: Int) {
        if let menu = self.menu {
            self.selectedMenuItem = menu[index]
        }
    }
    
    func createMenuItem() {
        
    }
    
    func updateMenuItem() {
        
    }
}

//
//  HomeViewModel.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import Foundation
import Combine

protocol HomeViewModelProtocol {
    var shopList: [Shop] {get set}
    var tableViewTitle: String {get set}
    var searchParam: SearchParam {get set}
    
    func getShopList(completion: @escaping () -> Void)
    func setSearchText(_ searchText: String)
//    var reloadDataClosure: (() -> Void) { get set }
}

class HomeViewModel: HomeViewModelProtocol {
    @Published var shopList: [Shop] = []
    var tableViewTitle: String = "Top Results"
    var searchParam: SearchParam
    @Published var loadingCompleted: Bool = false
    private var searchSubject = CurrentValueSubject<String, Never>("")
    private var cancellables: Set<AnyCancellable> = []
//    var reloadDataClosure: (() -> Void)?
    
    init() {
        self.searchParam = SearchParam(searchType: "name", sortBy: "rating", asc: true)
        setupSearchPublisher()
    }
    
    func getShopList(completion: @escaping () -> Void) {
        APIManager.shared.fetchShopList { result in
            switch result {
            case .success(let shopList):
                self.shopList = shopList.shopList
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    func setSearchText(_ searchText: String) {
        searchSubject.send(searchText)
    }
    
    func setupSearchPublisher() {
        searchSubject
            .debounce(for: .seconds(0.9), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.searchShop(search: searchText)
            }
            .store(in: &cancellables)
    }
    
    func searchShop(search: String) {
        APIManager.shared.searchShops(search: search, searchParam: self.searchParam)
            .sink { completion in
                switch completion {
                case .finished:
                    self.loadingCompleted = true
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] shopList in
                self?.shopList = shopList.shopList
                
                print(shopList)
            }
            .store(in: &cancellables)
    }
}

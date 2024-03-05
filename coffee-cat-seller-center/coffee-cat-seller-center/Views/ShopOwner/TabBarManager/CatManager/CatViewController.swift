//
//  CatViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 03/03/2024.
//

import UIKit
import Combine

class CatViewController: UIViewController {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: CatViewModelProtocol = CatViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    
    // MARK: - Create UIComponents
    lazy var areaTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let date = Date()
        self.loadData(date: getStringDateFormatter(date: date))
    }
    // MARK: - Setup UI
    private func setupUI() {
        configAppearance()
        view.addSubview(areaTableView)
        configAreaTableView()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray6
    }

    private func configAreaTableView() {
        areaTableView.dataSource = self
        areaTableView.delegate = self
        areaTableView.register(AreaCatTableViewCell.self, forCellReuseIdentifier: AreaCatTableViewCell.identifier)
        areaTableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            areaTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            areaTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            areaTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            areaTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Setup Data
    private func loadData(date: String) {
        if let shopId = UserSessionManager.shared.authenticationResponse?.accountResponse?.shopId {
            //_______________________________________________________________________________________________________________________________________
            self.viewModel.setAreasParam(shopId: shopId, date: date)
        }
        self.viewModel.setAreasParam(shopId: 1, date: date)
        self.viewModel.dataUpdatedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.areaTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Utitlities
    private func displayErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please choose table to submit\nYou can close without submit by click close button", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func getStringDateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateFormatterToStore
        return dateFormatter.string(from: date)
    }
}

extension CatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.viewModel.areaList?[section].name
        return self.viewModel.areaList?[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.areaList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AreaCatTableViewCell.identifier, for: indexPath) as? AreaCatTableViewCell else {
            return UITableViewCell()
        }
        
        if let catList = self.viewModel.areaList?[indexPath.section].catList {
            cell.configure(catList: catList)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightScaler(500)
    }
}

extension CatViewController: UITableViewDelegate {
    
}

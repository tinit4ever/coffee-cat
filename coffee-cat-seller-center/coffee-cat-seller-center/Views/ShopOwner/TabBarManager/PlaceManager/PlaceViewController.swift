//
//  PlaceViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 02/03/2024.
//

import UIKit
import Combine

class PlaceViewController: UIViewController, PlaceFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: PlaceViewModelProtocol = PlaceViewModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var selectedSeatIds: [SeatId] = [] {
        didSet {
            if selectedSeatIds.isEmpty {
                self.setDeleteButtonEnabled(false)
            } else {
                self.setDeleteButtonEnabled(true)
            }
        }
    }
    
    // MARK: - Create UIComponents
    lazy var managerStack = makeHorizontalStackView()
    lazy var deleteTableButton = makeButton()
    lazy var datePicker = makeDatePicker()
    lazy var addTableButton = makeButton()
    lazy var areaTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedSeatIds = []
        self.loadData(date: self.viewModel.date ?? "")
    }
    
    private func setupUI() {
        configAppearance()
        configNavigation()
        
        view.addSubview(managerStack)
        configManagerStack()
        
        view.addSubview(areaTableView)
        configAreaTableView()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray6
        view.backgroundColor = .systemBackground
    }
    
    private func configNavigation() {
    }
    
    private func configManagerStack() {
        managerStack.backgroundColor = .systemPurple
        managerStack.layer.cornerRadius = sizeScaler(10)
        managerStack.distribution = .equalCentering
        managerStack.layoutMargins = UIEdgeInsets(top: heightScaler(10), left: 30, bottom: heightScaler(10), right: 30)
        managerStack.isLayoutMarginsRelativeArrangement = true
        NSLayoutConstraint.activate([
            managerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: heightScaler(10)),
            managerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(30)),
            managerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-30))
        ])
        managerStack.addArrangedSubview(deleteTableButton)
        deleteTableButton.isEnabled = false
        deleteTableButton.setImage(UIImage(systemName: "trash")?.withTintColor(.systemBackground, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(30), height: heightScaler(35))), for: .normal)
        
        managerStack.addArrangedSubview(datePicker)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minimumDate = Date()
        datePicker.tintColor = .customBlack
        datePicker.backgroundColor = .systemCyan
        datePicker.layer.cornerRadius = sizeScaler(10)
        datePicker.layer.masksToBounds = true
        
        managerStack.addArrangedSubview(addTableButton)
        addTableButton.setImage(UIImage(systemName: "plus")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(40), height: heightScaler(35))), for: .normal)
    }
    
    private func configAreaTableView() {
        areaTableView.delegate = self
        areaTableView.dataSource = self
        areaTableView.register(AreaTableViewCell.self, forCellReuseIdentifier: AreaTableViewCell.identifier)
        areaTableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            areaTableView.topAnchor.constraint(equalTo: managerStack.bottomAnchor, constant: heightScaler(20)),
            areaTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            areaTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            areaTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -heightScaler(80))
        ])
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        self.datePicker.addTarget(self, action: #selector(dateChange(_:)), for: .valueChanged)
        self.addTableButton.addTarget(self, action: #selector(addSeatTapped), for: .touchUpInside)
        self.deleteTableButton.addTarget(self, action: #selector(deleteTableButtonTapped), for: .touchUpInside)
        
        setupCombineSubject()
    }
    
    private func setupCombineSubject() {
        self.viewModel.deleteResponsePublisher
            .sink { result in
                switch result {
                case .success():
                    self.selectedSeatIds = []
                    self.viewModel.areaList = nil
                    self.viewModel.selectedSeat = nil
                    self.displaySuccess()
                    let date = self.getStringDateFormatter(date: Date())
                    self.loadData(date: date)
                case .failure(let error):
                    self.displayErrorAlert(message: error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Catch Action
    @objc
    private func dateChange(_ datePicker: UIDatePicker) {
        loadData(date: self.getStringDateFormatter(date: datePicker.date))
    }
    
    @objc
    private func datePickerTapped() {
        datePicker.becomeFirstResponder()
    }
    
    @objc private func addSeatTapped() {
        let viewModel = InputAreaViewModel()
        if let areaList = self.viewModel.areaList {
            viewModel.areaList = areaList
        }
        let inputAreaViewController = InputAreaViewController(viewModel: viewModel)
        inputAreaViewController.dismissCompletion = { [weak self] in
            DispatchQueue.main.async {
                guard let date = self?.getStringDateFormatter(date: Date()) else {
                    return
                }
                self?.loadData(date: date)
            }
        }
        let navigationController = UINavigationController(rootViewController: inputAreaViewController)
        present(navigationController, animated: true)
    }
    
    @objc private func deleteTableButtonTapped() {
        self.viewModel.deleteSeats()
    }
    
    // MARK: - Utitlities
    private func displayErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func displaySuccess() {
        let alertController = UIAlertController(title: "Success", message: "Tables is deleted", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func getStringDateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateFormatterToStore
        return dateFormatter.string(from: date)
    }
    
    private func loadData(date: String) {
        if let shopId = UserSessionManager.shared.authenticationResponse?.accountResponse?.shopId {
            self.viewModel.setAreasParam(shopId: shopId, date: date)
        }
        
        self.viewModel.dataUpdatedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.areaTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setDeleteButtonEnabled(_ isEnabled: Bool) {
        self.deleteTableButton.isEnabled = isEnabled
        var color: UIColor = .systemBackground
        if isEnabled {
            color = .systemRed
        } else {
            color = .systemBackground
        }
        deleteTableButton.setImage(UIImage(systemName: "trash")?.withTintColor(color, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(30), height: heightScaler(35))), for: .normal)
    }
}

extension PlaceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightScaler(370)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.areaList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.viewModel.areaList?[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AreaTableViewCell.identifier, for: indexPath) as? AreaTableViewCell else {
            return UITableViewCell()
        }
        
        if let areaList = self.viewModel.areaList, indexPath.section < areaList.count {
            if let seatList = areaList[indexPath.section].seatList {
                cell.configure(seatList: seatList)
            }
        } else {
            print("Invalid section index: \(indexPath.section)")
        }
        
        cell.didSelectedSeat = { [weak self] seatId, isAdd in
            if isAdd {
                self?.selectedSeatIds.append(seatId)
            } else {
                if let indexToRemove = self?.selectedSeatIds.firstIndex(where: { $0.id == seatId.id }) {
                    self?.selectedSeatIds.remove(at: indexToRemove)
                }
            }
            
            print(self?.selectedSeatIds as Any)
            self?.viewModel.selectedSeat = self?.selectedSeatIds
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension PlaceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
}

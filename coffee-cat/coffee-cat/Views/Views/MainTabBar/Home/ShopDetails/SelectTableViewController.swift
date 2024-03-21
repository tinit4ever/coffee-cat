//
//  SelectTableViewController.swift
//  coffee-cat
//
//  Created by Tin on 25/02/2024.
//

import UIKit
import SwiftUI
import Combine

class SelectTableViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var didSendData: (((Seat, String)?) -> Void)?
    
    var viewModel: SelectTableViewModelProtocol = SelectTableViewModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Create UIComponents
    lazy var datePicker = makeDatePicker()
    lazy var areaTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var noteStack = makeVerticalStackView()

    lazy var notSelectStack = makeHorizontalStackView()
    lazy var notSelectView = makeView()
    lazy var notSelect = makeLabel()
    
    lazy var disableStack = makeHorizontalStackView()
    lazy var disableView = makeView()
    lazy var disable = makeLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData(date: self.viewModel.date ?? "")
    }
    
    private func setupUI() {
        configAppearance()
        configNavigation()
        
        view.addSubview(noteStack)
        setupStackData()
        configNoteStack()
        
        view.addSubview(areaTableView)
        configAreaTableView()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray6
        view.backgroundColor = .systemBackground
    }
    
    private func configNavigation() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .customPink
        
        let datePicker = UIBarButtonItem(customView: datePicker)
        configDatePicker()
        
        self.navigationItem.leftBarButtonItems = [cancelButton]
        self.navigationItem.rightBarButtonItem = datePicker
    }
    
    private func configDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minimumDate = Date()
        datePicker.tintColor = .customBlack
    }
    
    private func setupStackData() {
        notSelectView.widthAnchor.constraint(equalToConstant: widthScaler(60)).isActive = true
        notSelectView.heightAnchor.constraint(equalToConstant: widthScaler(60)).isActive = true
        notSelectView.layer.cornerRadius = sizeScaler(10)
        notSelectView.backgroundColor = .systemBlue
        
        notSelect.setupTitle(text: "Position is ready to choose", fontName: FontNames.avenir, size: sizeScaler(28), textColor: .customBlack)
        notSelect.textAlignment = .left
        
        disableView.widthAnchor.constraint(equalToConstant: widthScaler(60)).isActive = true
        disableView.heightAnchor.constraint(equalToConstant: widthScaler(60)).isActive = true
        disableView.layer.cornerRadius = sizeScaler(10)
        disableView.backgroundColor = .systemGray3
        
        disable.setupTitle(text: "Position is not available", fontName: FontNames.avenir, size: sizeScaler(28), textColor: .customBlack)
        disable.textAlignment = .left
    }
    
    private func configNoteStack() {
        noteStack.spacing = heightScaler(10)
        NSLayoutConstraint.activate([
            noteStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: heightScaler(20)),
            noteStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(80)),
            noteStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-80)),
        ])
        noteStack.addArrangedSubview(notSelectStack)
        notSelectStack.spacing = widthScaler(30)
        notSelectStack.addArrangedSubview(notSelectView)
        notSelectStack.addArrangedSubview(notSelect)
        
        noteStack.addArrangedSubview(disableStack)
        disableStack.spacing = widthScaler(30)
        disableStack.addArrangedSubview(disableView)
        disableStack.addArrangedSubview(disable)
    }
    
    private func configAreaTableView() {
        areaTableView.delegate = self
        areaTableView.dataSource = self
        areaTableView.register(AreaTableViewCell.self, forCellReuseIdentifier: AreaTableViewCell.identifier)
        areaTableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            areaTableView.topAnchor.constraint(equalTo: noteStack.bottomAnchor, constant: heightScaler(10)),
            areaTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            areaTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            areaTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        self.datePicker.addTarget(self, action: #selector(dateChange(_:)), for: .valueChanged)
    }
    
    // MARK: - Catch Action
    @objc 
    private func cancelButtonTapped() {
        self.dismiss(animated: true)
        self.didSendData?(nil)
    }
    
    @objc
    private func dateChange(_ datePicker: UIDatePicker) {
        loadData(date: self.getStringDateFormatter(date: datePicker.date))
    }
    
    @objc
    private func datePickerTapped() {
        datePicker.becomeFirstResponder()
    }
    
    // MARK: - Utitlities
    
    private func getStringDateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateFormatterToStore
        return dateFormatter.string(from: date)
    }
    
    private func loadData(date: String) {
        self.viewModel.setAreasParam(shopId: self.viewModel.shopId, date: date)
        self.viewModel.dataUpdatedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.areaTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func submitSeat(areaIndex: IndexPath, seatIndex: IndexPath) {
        if let areaList = self.viewModel.areaList {
            if let seatList = areaList[areaIndex.section].seatList {
                let seat = seatList[seatIndex.row]
                let date = self.getStringDateFormatter(date: self.datePicker.date)
                self.didSendData?((seat, date))
                self.dismiss(animated: true)
            }
        }
    }
}

extension SelectTableViewController: UITableViewDataSource {
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
                cell.configure(seatList: seatList, indexPath: indexPath)
            }
        } else {
            print("Invalid section index: \(indexPath.section)")
        }
        
        cell.sendSelectedTableIndex = { [weak self] selectedAreaIndex, selectedSeatIndex in
            self?.submitSeat(areaIndex: selectedAreaIndex, seatIndex: selectedSeatIndex)
        }

        return cell
    }
}

extension SelectTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select")
    }
    
}

// -MARK: Preview
struct SelectTableViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let selectTableViewController = SelectTableViewController()
            return selectTableViewController
        }
    }
}

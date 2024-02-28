//
//  SelectTableViewController.swift
//  coffee-cat
//
//  Created by Tin on 25/02/2024.
//

import UIKit
import SwiftUI

class SelectTableViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var didSendData: (([String]) -> Void)?
    var areaList: [Area] = []
    
    // MARK: - Create UIComponents
    lazy var datePicker = makeDatePicker()
    
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
    
    private func setupUI() {
        configAppearance()
        configNavigation()
        
        view.addSubview(areaTableView)
        configAreaTableView()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray6
    }
    
    private func configNavigation() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .customPink
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = .customPink
        
        let datePicker = UIBarButtonItem(customView: datePicker)
        configDatePicker()
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = widthScaler(100)
        
        self.navigationItem.leftBarButtonItems = [cancelButton, space, datePicker]
        self.navigationItem.rightBarButtonItem = doneButton
    }

    private func configDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minimumDate = Date()
        datePicker.tintColor = .customBlack
    }
    
    private func configAreaTableView() {
        areaTableView.delegate = self
        areaTableView.dataSource = self
        areaTableView.register(AreaTableViewCell.self, forCellReuseIdentifier: AreaTableViewCell.identifier)
        areaTableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            areaTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
    }
    
    @objc 
    private func doneButtonTapped() {
//        didSendData?(self.selectedTable)
        self.dismiss(animated: true)
    }
    
    @objc
    private func dateChange(_ datePicker: UIDatePicker) {
        print(datePicker.date)
        DispatchQueue.main.async {
            self.datePicker.endEditing(true)
        }
    }
    
    @objc
    private func datePickerTapped() {
        datePicker.becomeFirstResponder()
    }
}

extension SelectTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightScaler(240)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.areaList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.areaList[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AreaTableViewCell.identifier, for: indexPath) as? AreaTableViewCell else {
            return UITableViewCell()
        }
        
        if let seatList = self.areaList[indexPath.section].seatList {
            cell.configure(seatList: seatList)
        }
        
        return cell
    }
}

extension SelectTableViewController: UITableViewDelegate {
    
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


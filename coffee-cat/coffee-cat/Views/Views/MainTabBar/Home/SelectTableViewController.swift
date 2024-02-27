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
    lazy var areaTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .customPink
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = .customPink
        
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configAreaTableView() {
        areaTableView.delegate = self
        areaTableView.dataSource = self
        areaTableView.register(AreaTableViewCell.self, forCellReuseIdentifier: AreaTableViewCell.identifier)
        areaTableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            areaTableView.topAnchor.constraint(equalTo: view.topAnchor),
            areaTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            areaTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            areaTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
//        didSendData?(self.selectedTable)
        self.dismiss(animated: true)
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


//
//  CatListViewController.swift
//  coffee-cat
//
//  Created by Tin on 28/02/2024.
//

import UIKit

class CatListViewController: UIViewController {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
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
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelButtonTapped))
        
        self.navigationItem.leftBarButtonItems = [cancelButton]
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
    
    @objc
    private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
}

extension CatListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.areaList[section].name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.areaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AreaCatTableViewCell.identifier, for: indexPath) as? AreaCatTableViewCell else {
            return UITableViewCell()
        }
        
        if let catList = self.areaList[indexPath.section].catList {
            cell.configure(catList: catList)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightScaler(500)
    }
}

extension CatListViewController: UITableViewDelegate {
    
}

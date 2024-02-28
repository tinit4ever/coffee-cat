//
//  StaffAccountViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 27/02/2024.
//

import UIKit

class StaffAccountViewController: UIViewController, StaffAccountFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    // -MARK: Create UI Components
    lazy var topView = makeView()
    lazy var topViewLabel = makeLabel()
    lazy var coffeeAnimationView = makeLottieAnimationView(animationName: "coffee")
    lazy var accountImageButton = makeImageView(imageName: "person.circle", size: CGSize(width: sizeScaler(60), height: sizeScaler(60)))
    
    lazy var accountTableContainer = makeView()
    lazy var accountTableView = makeTableView()
    lazy var addAccountButton = makeButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemMint.withAlphaComponent(0.8)
        
        view.addSubview(topView)
        configTopView()
        
        view.addSubview(accountTableContainer)
        configAccountTableView()
    }
    
    private func configTopView() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
            topView.heightAnchor.constraint(equalToConstant: sizeScaler(80)),
        ])
        
        topView.addSubview(coffeeAnimationView)
        coffeeAnimationView.play()
        configCoffeeAnimationView()
        
        topView.addSubview(topViewLabel)
        configTopViewLabel()
        
        topView.addSubview(accountImageButton)
        configAccountImageButton()
    }
    
    private func configCoffeeAnimationView() {
        coffeeAnimationView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            coffeeAnimationView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            coffeeAnimationView.widthAnchor.constraint(equalToConstant: sizeScaler(60)),
            coffeeAnimationView.heightAnchor.constraint(equalTo: topView.heightAnchor),
            coffeeAnimationView.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
        ])
    }
    
    private func configTopViewLabel() {
        topViewLabel.setupTitle(text: "Hello!", fontName: FontNames.avenir, size: sizeScaler(45), textColor: .customBlack)
        NSLayoutConstraint.activate([
            topViewLabel.leadingAnchor.constraint(equalTo: coffeeAnimationView.trailingAnchor, constant: sizeScaler(20)),
            topViewLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor)
        ])
    }
    
    private func configAccountImageButton() {
        accountImageButton.image = accountImageButton.image?.withRenderingMode(.alwaysTemplate)
        accountImageButton.tintColor = .customBlack
        NSLayoutConstraint.activate([
            accountImageButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            accountImageButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
        ])
    }
    
    private func configAccountTableView() {
        accountTableContainer.layer.cornerRadius = sizeScaler(20)
        accountTableContainer.layer.masksToBounds = true
        accountTableContainer.backgroundColor = .systemBackground
        
        accountTableContainer.addSubview(accountTableView)
        accountTableView.delegate = self
        accountTableView.dataSource = self
        accountTableView.register(AccountTableViewCell.self, forCellReuseIdentifier: AccountTableViewCell.identifier)
        
        accountTableContainer.addSubview(addAccountButton)
        addAccountButton.backgroundColor = .green.withAlphaComponent(0.8)
        addAccountButton.setTitle(title: "+", fontName: FontNames.avenir, size: sizeScaler(60), color: .black)
        
        NSLayoutConstraint.activate([
            accountTableContainer.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: heightScaler(40)),
            accountTableContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(30)),
            accountTableContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(30)),
            accountTableContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -heightScaler(80)),
            
            accountTableView.topAnchor.constraint(equalTo: accountTableContainer.topAnchor),
            accountTableView.leadingAnchor.constraint(equalTo: accountTableContainer.leadingAnchor),
            accountTableView.trailingAnchor.constraint(equalTo: accountTableContainer.trailingAnchor),
            accountTableView.bottomAnchor.constraint(equalTo: accountTableContainer.bottomAnchor, constant: -heightScaler(80)),
            
            addAccountButton.topAnchor.constraint(equalTo: accountTableView.bottomAnchor, constant: heightScaler(20)),
            addAccountButton.leadingAnchor.constraint(equalTo: accountTableContainer.leadingAnchor),
            addAccountButton.trailingAnchor.constraint(equalTo: accountTableContainer.trailingAnchor),
            addAccountButton.bottomAnchor.constraint(equalTo: accountTableContainer.bottomAnchor)
        ])
    }
}

extension StaffAccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.identifier, for: indexPath) as? AccountTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightScaler(60)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Accounts"
    }
}

extension StaffAccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            // Delete loddgic here
            completionHandler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let updateAction = UIContextualAction(style: .normal, title: "Update") { _, _, completionHandler in
            // Update logic here
            completionHandler(true)
        }
        
        updateAction.backgroundColor = UIColor.systemBrown
        let configuration = UISwipeActionsConfiguration(actions: [updateAction])
        return configuration
    }

}
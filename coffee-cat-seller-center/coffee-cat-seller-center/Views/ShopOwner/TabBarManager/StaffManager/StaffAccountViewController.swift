//
//  StaffAccountViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 27/02/2024.
//

import UIKit
import Combine

class StaffAccountViewController: UIViewController, StaffAccountFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var cancellables: Set<AnyCancellable> = []
    var viewModel: StaffAccountViewModelProtocol = StaffAccountViewModel()
    
    // -MARK: Create UI Components
    lazy var topView = makeView()
    lazy var topViewLabel = makeLabel()
    lazy var coffeeAnimationView = makeLottieAnimationView(animationName: "coffee")
    lazy var accountAnimationButton = makeLottieAnimationView(animationName: "person")
    
    lazy var accountTableContainer = makeView()
    lazy var accountTableView = makeTableView()
    lazy var addAccountButton = makeButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemMint.withAlphaComponent(0.8)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
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
        
        topView.addSubview(accountAnimationButton)
        configAccountAnimationButton()
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
        if let username = UserSessionManager.shared.authenticationResponse?.accountResponse?.name {
            topViewLabel.setupTitle(text: "Hello \(String(describing: username))!", fontName: FontNames.avenir, size: sizeScaler(45), textColor: .customBlack)
        } else {
            topViewLabel.setupTitle(text: "Hello!", fontName: FontNames.avenir, size: sizeScaler(45), textColor: .customBlack)
        }
        NSLayoutConstraint.activate([
            topViewLabel.leadingAnchor.constraint(equalTo: coffeeAnimationView.trailingAnchor, constant: sizeScaler(20)),
            topViewLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor)
        ])
    }
    
    private func configAccountAnimationButton() {
        accountAnimationButton.contentMode = .scaleAspectFit
        accountAnimationButton.play()
        NSLayoutConstraint.activate([
            accountAnimationButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            accountAnimationButton.widthAnchor.constraint(equalToConstant: sizeScaler(110)),
            accountAnimationButton.heightAnchor.constraint(equalTo: topView.heightAnchor),
            accountAnimationButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
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
    
    // -MARK: Setup Data
    private func setupData() {
        let getParameter = GetParameter(sortByColumn: "status", asc: true)
        if let accessToken = UserSessionManager.shared.getAccessToken() {
            self.viewModel.getListOfStaff(accessToken: accessToken, getParameter: getParameter) { [weak self] in
                DispatchQueue.main.async {
                    self?.accountTableView.reloadData()
                }
            }
        }
    }
    
    // -MARK: Setup Action
    private func setupAction() {
        self.addAccountButton.addTarget(self, action: #selector(addAccountButtonTapped), for: .touchUpInside)
        
        let accountAnimationButtonGesture = UITapGestureRecognizer(target: self, action: #selector(accountAnimationButtonTapped))
        self.accountAnimationButton.addGestureRecognizer(accountAnimationButtonGesture)
        self.accountAnimationButton.isUserInteractionEnabled = true
        
        self.viewModel.isChangeStatusSubject
            .sink { result in
                switch result {
                case .success:
                    self.setupData()
                case .failure(let error):
                    self.displayErrorAlert(message: "Error: \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
    }
    
    // -MARK: Catch Action
    @objc
    private func accountAnimationButtonTapped() {
        let navigationController = UINavigationController(rootViewController: ProfileViewController())
        self.present(navigationController, animated: true)
    }
    
    @objc
    private func addAccountButtonTapped() {
        let accountInputViewModel: AccountInputViewModelProtocol = AccountInputViewModel()
        accountInputViewModel.accountCreation = CreateAccountModel(email: "", password: "", name: "", phone: "")
        let viewController = AccountInputViewController(viewModel: accountInputViewModel)
        viewController.dismissCompletion = { [weak self] in
            DispatchQueue.main.async {
                self?.setupData()
            }
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true)
    }
    
    private func unbanAccount(indexPath: IndexPath) {
        let staffId = self.viewModel.staffList[indexPath.row].id
        if let accessToken = UserSessionManager.shared.getAccessToken() {
            self.viewModel.unbanStaff(staffId: staffId, accessToken: accessToken)
        }
    }
    
    private func banAccount(indexPath: IndexPath) {
        let staffId = self.viewModel.staffList[indexPath.row].id
        if let accessToken = UserSessionManager.shared.getAccessToken() {
            self.viewModel.banStaff(staffId: staffId, accessToken: accessToken)
        }
    }
    
    private func updateAccount(indexPath: IndexPath) {
        let account = self.viewModel.staffList[indexPath.row]
        let accountInputViewModel: AccountInputViewModelProtocol = AccountInputViewModel()
        
        guard let name = account.name,
              let phone = account.phone else {
            return
        }
        
        let email = account.email
        
        let accountModel = CreateAccountModel(email: "", password: "", name: "", phone: "")
        accountInputViewModel.accountCreation = accountModel
        accountInputViewModel.setId(id: account.id)
        accountInputViewModel.setName(name: name)
        accountInputViewModel.setEmail(email: email)
        accountInputViewModel.setPhone(phone: phone)
        accountInputViewModel.initEmailWhenUpdate = email
        let viewController = AccountInputViewController(viewModel: accountInputViewModel)
        viewController.dismissCompletion = { [weak self] in
            DispatchQueue.main.async {
                self?.setupData()
            }
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true)
    }
    
    // -MARK: Utilities
    private func displayErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension StaffAccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.staffList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.identifier, for: indexPath) as? AccountTableViewCell else {
            return UITableViewCell()
        }
        
        let account = self.viewModel.staffList[indexPath.row]
        cell.config(account: account)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightScaler(120)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Accounts"
    }
}

extension StaffAccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accountStatus = self.viewModel.staffList[indexPath.row].status
        if accountStatus == .active {
            let banAction = UIContextualAction(style: .destructive, title: "Deactive") { _, _, completionHandler in
                self.banAccount(indexPath: indexPath)
                completionHandler(true)
            }
            let configuration = UISwipeActionsConfiguration(actions: [banAction])
            return configuration
        } else {
            let unBanAction = UIContextualAction(style: .normal, title: "Active") { _, _, completionHandler in
                self.unbanAccount(indexPath: indexPath)
                completionHandler(true)
            }
            unBanAction.backgroundColor = .systemGreen
            let configuration = UISwipeActionsConfiguration(actions: [unBanAction])
            return configuration
        }
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let updateAction = UIContextualAction(style: .normal, title: "Update") { _, _, completionHandler in
            self.updateAccount(indexPath: indexPath)
            completionHandler(true)
        }
        
        updateAction.backgroundColor = UIColor.systemBrown
        let configuration = UISwipeActionsConfiguration(actions: [updateAction])
        return configuration
    }
}

//
//  BookingManagerViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 05/03/2024.
//

import UIKit
import SwiftUI
import Combine

class BookingManagerViewController: UIViewController, BookingManagerFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    let segmenItems = ["PENDING", "CONFIRMED", "CANCELLED"]
    
    var cancellables: Set<AnyCancellable> = []
    var viewModel: BookingManagerViewModelProtocol = BookingManagerViewModel()
    
    // -MARK: Create UI Components
    lazy var header = makeView()
    lazy var headerLabel = makeLabel()
    lazy var coffeeAnimationView = makeLottieAnimationView(animationName: "coffee")
    lazy var accountAnimationButton = makeLottieAnimationView(animationName: "person")
    
    lazy var shopNameLabel = makeLabel()
    
    lazy var segmentedControl: UISegmentedControl = {
        var segment = UISegmentedControl(items: segmenItems)
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    lazy var bookingTableViewContainer = makeView()
    lazy var bookingTableView = makeTableView()
    
    lazy var popupView = makePopupView(frame: CGRect(x: 200, y: 400, width: widthScaler(500), height: heightScaler(175)))
    lazy var blurView = makeBlurView(frame: view.bounds, effect: UIBlurEffect(style: .systemUltraThinMaterial))
    
    lazy var menuItemListLabel = makeLabel()
    
    lazy var menuItems: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = true
        return textView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        setupAsync()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.setupData()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemTeal
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        view.addSubview(header)
        configHeader()
        
        view.addSubview(shopNameLabel)
        configShopNameLabel()
        
        view.addSubview(segmentedControl)
        configSegmentedControl()
        
        view.addSubview(bookingTableViewContainer)
        configBookingTableViewContainer()
        
        view.addSubview(blurView)
        view.addSubview(popupView)
        configPopupView()
    }
    
    private func configHeader() {
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
            header.heightAnchor.constraint(equalToConstant: sizeScaler(80)),
        ])
        
        header.addSubview(coffeeAnimationView)
        coffeeAnimationView.play()
        configCoffeeAnimationView()
        
        header.addSubview(headerLabel)
        configHeaderLabel()
        
        header.addSubview(accountAnimationButton)
        configAccountAnimationButton()
    }
    
    private func configCoffeeAnimationView() {
        coffeeAnimationView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            coffeeAnimationView.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            coffeeAnimationView.widthAnchor.constraint(equalToConstant: sizeScaler(60)),
            coffeeAnimationView.heightAnchor.constraint(equalTo: header.heightAnchor),
            coffeeAnimationView.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
    }
    
    private func configHeaderLabel() {
        if let username = UserSessionManager.shared.authenticationResponse?.accountResponse?.name {
            headerLabel.setupTitle(text: "Hello \(String(describing: username))!", fontName: FontNames.avenir, size: sizeScaler(45), textColor: .customBlack)
        } else {
            headerLabel.setupTitle(text: "Hello!", fontName: FontNames.avenir, size: sizeScaler(45), textColor: .customBlack)
        }
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: coffeeAnimationView.trailingAnchor, constant: sizeScaler(20)),
            headerLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor)
        ])
    }
    
    private func configAccountAnimationButton() {
        accountAnimationButton.contentMode = .scaleAspectFit
        accountAnimationButton.play()
        NSLayoutConstraint.activate([
            accountAnimationButton.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            accountAnimationButton.widthAnchor.constraint(equalToConstant: sizeScaler(110)),
            accountAnimationButton.heightAnchor.constraint(equalTo: header.heightAnchor),
            accountAnimationButton.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
    }
    
    private func configShopNameLabel() {
        shopNameLabel.setupTitle(text: "Shop Name", fontName: FontNames.avenir, size: sizeScaler(50), textColor: .customBlack)
        shopNameLabel.setBoldText()
        NSLayoutConstraint.activate([
            self.shopNameLabel.topAnchor.constraint(equalTo: header.bottomAnchor, constant: heightScaler(30)),
            self.shopNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(20)),
            self.shopNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-20)),
            self.shopNameLabel.heightAnchor.constraint(equalToConstant: sizeScaler(60))
        ])
    }
    
    private func configSegmentedControl() {
        NSLayoutConstraint.activate([
            self.segmentedControl.topAnchor.constraint(equalTo: shopNameLabel.bottomAnchor, constant: heightScaler(30)),
            self.segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            self.segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-60)),
            self.segmentedControl.heightAnchor.constraint(equalToConstant: sizeScaler(60))
        ])
    }
    
    private func configBookingTableViewContainer() {
        bookingTableViewContainer.backgroundColor = .clear
        bookingTableView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            self.bookingTableViewContainer.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: heightScaler(30)),
            self.bookingTableViewContainer.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor),
            self.bookingTableViewContainer.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor),
            self.bookingTableViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: heightScaler(-40)),
        ])
        
        
        self.bookingTableViewContainer.addSubview(bookingTableView)
        self.bookingTableView.separatorStyle = .none
        self.bookingTableView.delegate = self
        self.bookingTableView.dataSource = self
        self.bookingTableView.register(BookingHistoryTableViewCell.self, forCellReuseIdentifier: BookingHistoryTableViewCell.identifier)
        
        NSLayoutConstraint.activate([
            self.bookingTableView.topAnchor.constraint(equalTo: bookingTableViewContainer.topAnchor),
            self.bookingTableView.leadingAnchor.constraint(equalTo: bookingTableViewContainer.leadingAnchor),
            self.bookingTableView.trailingAnchor.constraint(equalTo: bookingTableViewContainer.trailingAnchor),
            self.bookingTableView.bottomAnchor.constraint(equalTo: bookingTableViewContainer.bottomAnchor, constant: heightScaler(-25)),
        ])
        self.bookingTableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    private func configPopupView() {
        let viewWidth: CGFloat = view.frame.size.width - widthScaler (100)
        let viewHeight: CGFloat = heightScaler(400)

        let centerX = view.frame.size.width / 2.0
        let centerY = view.frame.size.height / 2.0
        
        popupView.frame = CGRect(x: centerX - (viewWidth / 2.0), y: centerY / 2, width: viewWidth, height: viewHeight)

        popupView.addSubview(menuItems)
        menuItems.frame = CGRect(x: widthScaler(40), y: heightScaler(10), width: popupView.frame.width - widthScaler(80) , height: popupView.frame.height - heightScaler(20))
        menuItems.font = UIFont(name: FontNames.avenir, size: sizeScaler(30))
    }
    
    // -MARK: Setup Async
    private func setupAsync() {
        self.viewModel.isGetDataCompletedSubject
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success():
                    self.segmentedControl.selectedSegmentIndex = 0
                    self.bookingTableView.reloadData()
                    self.refreshControl.endRefreshing()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
        self.viewModel.isApprovedSubject
            .sink { result in
                switch result {
                case .success():
                    self.showSuccess(message: "Booking have been approved")
                    self.setupData()
                case .failure(let error):
                    self.showError(message: "Error \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
        
        self.viewModel.isRejectedSubject
            .sink { result in
                switch result {
                case .success():
                    self.showSuccess(message: "Booking have been rejected")
                    self.setupData()
                case .failure(let error):
                    self.showError(message: "Error \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
    }
    
    // -MARK: Setup Data
    private func setupData() {
        if let shopName = UserSessionManager.shared.authenticationResponse?.accountResponse?.shopName {
            self.shopNameLabel.text = shopName
        }
        self.viewModel.getBookingList()
    }
    
    // -MARK: Setup Action
    private func setupAction() {
        let accountAnimationButtonGesture = UITapGestureRecognizer(target: self, action: #selector(accountAnimationButtonTapped))
        self.accountAnimationButton.addGestureRecognizer(accountAnimationButtonGesture)
        self.accountAnimationButton.isUserInteractionEnabled = true
        
        self.segmentedControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        blurView.addGestureRecognizer(tapGesture)
    }
    
    // -MARK: Catch Action
    @objc
    private func accountAnimationButtonTapped() {
        let navigationController = UINavigationController(rootViewController: ProfileViewController())
        self.present(navigationController, animated: true)
    }
    
    @objc
    private func segmentValueChanged(_ sender: UISegmentedControl) {
        let selectedSegment = sender.selectedSegmentIndex
        
        switch selectedSegment {
        case 0:
            print("PENDING")
            self.viewModel.updateCurrentList(currentStatus: .pending)
        case 1:
            print("CONFIRMED")
            self.viewModel.updateCurrentList(currentStatus: .confirmed)
        case 2:
            print("CANCELLED")
            self.viewModel.updateCurrentList(currentStatus: .cancelled)
        default:
            print("No segment is selected")
        }
        
        DispatchQueue.main.async {
            self.bookingTableView.reloadData()
        }
    }
    
    @objc
    private func pullToRefresh() {
        self.refreshControl.beginRefreshing()
        DispatchQueue.main.async {
            self.viewModel.getBookingList()
        }
    }
    
    @objc
    func dismissPopup() {
        UIView.animate(withDuration: 0.3) {
            self.popupView.alpha = 0
            self.blurView.alpha = 0
        }
    }
    
    // -MARK: Utilities
    private func showSuccess(message: String) {
        let alertController = UIAlertController(title: "Sucess", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func rejectBookingTapped(indexPath: IndexPath) {
        self.rejectRemind(title: "Confirm", message: "Are you sure you want to reject this booking?", indexPath: indexPath)
    }
    
    private func approveBooking(indexPath: IndexPath) {
        self.viewModel.attachedBookingId = self.viewModel.currentList[indexPath.row].bookingId
        self.viewModel.approveBooking()
    }
    
    private func rejectBooking(indexPath: IndexPath) {
        self.viewModel.attachedBookingId = self.viewModel.currentList[indexPath.row].bookingId
        self.viewModel.rejectBooking()
    }
    
    private func rejectRemind(title: String, message: String, indexPath: IndexPath) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.rejectBooking(indexPath: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { action in
            self.dismiss(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func generateMenuList(bookingDetails: BookingDetail) {
        let itemList = bookingDetails.itemResponseList
        var menuDetails: String = ""
        for (index, item) in itemList.enumerated() {
            if index != itemList.count - 1 {
                menuDetails += item.itemName + ": " + String(describing: item.quantity) + "\n\n"
            } else {
                menuDetails += item.itemName + ": " + String(describing: item.quantity) + "\n"
            }
        }
        
        let totalPrice = bookingDetails.totalPrice
        menuDetails = menuDetails + "_______________________________\nTotal Price: \(totalPrice)$"
        
        self.menuItems.text = menuDetails
    }
    
    private func showPopupView() {
        UIView.animate(withDuration: 0.3) {
            self.popupView.alpha = 1 - self.popupView.alpha
            self.blurView.alpha = 1 - self.blurView.alpha
        }
    }
}

extension BookingManagerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.currentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingHistoryTableViewCell.identifier, for: indexPath) as? BookingHistoryTableViewCell else {
            return UITableViewCell()
        }
        
        let bookingDetail = self.viewModel.currentList[indexPath.row]
        cell.configure(bookingDetail: bookingDetail)
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}

extension BookingManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookingDetails = self.viewModel.currentList[indexPath.row]
        self.generateMenuList(bookingDetails: bookingDetails)
        showPopupView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightScaler(160)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if segmentedControl.selectedSegmentIndex == 0 {
            let confirmAction = UIContextualAction(style: .normal, title: "Confirm") { _, _, completionHandler in
                self.approveBooking(indexPath: indexPath)
                completionHandler(true)
            }
            let image = UIImage(systemName: "checkmark.seal")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(40), height: heightScaler(40)))
            confirmAction.image = image
            confirmAction.backgroundColor = .systemTeal
            return UISwipeActionsConfiguration(actions: [confirmAction])
        } else {
            return UISwipeActionsConfiguration(actions: [])
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if segmentedControl.selectedSegmentIndex == 0 {
            let refuseAction = UIContextualAction(style: .normal, title: "Refuse") { _, _, completionHandler in
                self.rejectBookingTapped(indexPath: indexPath)
                completionHandler(true)
            }
            let image = UIImage(systemName: "xmark.seal")?.withTintColor(.systemPurple, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(40), height: heightScaler(40)))
            refuseAction.image = image
            refuseAction.backgroundColor = .systemTeal
            return UISwipeActionsConfiguration(actions: [refuseAction])
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let deleteAction = UIContextualAction(style: .destructive, title: "Cancel") { _, _, completionHandler in
                self.rejectBookingTapped(indexPath: indexPath)
                completionHandler(true)
            }
            let image = UIImage(systemName: "trash")?.withTintColor(.systemPurple, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(40), height: heightScaler(40)))
            deleteAction.image = image
            deleteAction.backgroundColor = .systemTeal
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
        } else {
            return UISwipeActionsConfiguration(actions: [])
        }
    }
}

// -MARK: Preview
struct BookingViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let bookingManagerViewController = BookingManagerViewController()
            return bookingManagerViewController
        }
    }
}


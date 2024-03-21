//
//  BookingViewController.swift
//  coffee-cat
//
//  Created by Tin on 31/01/2024.
//

import UIKit
import Combine

class BookingViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    let segmenItems = ["PENDING", "CONFIRMED", "CANCELLED"]
    var viewModel: BookingViewModelProtocol = BookingViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: Create UIComponents
    lazy var topView = makeView()
    lazy var viewTitle = makeLabel()
    lazy var segmentedControl: SquareSegmentedControl = {
        var segment = SquareSegmentedControl(items: segmenItems)
        //        segment.frame = .zero
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    lazy var bookingTableViewContainer = makeView()
    lazy var bookingTableView = makeTableView()
    
    private let refreshControl = UIRefreshControl()
    
    
    lazy var popupView = makePopupView(frame: CGRect(x: 200, y: 400, width: widthScaler(500), height: heightScaler(175)))
    lazy var blurView = makeBlurView(frame: view.bounds, effect: UIBlurEffect(style: .systemUltraThinMaterial))
    
    lazy var menuItemListLabel = makeLabel()
    
    lazy var menuItems: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = true
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        loadData()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UserSessionManager.shared.isLoggedIn() {
            self.displayLoginRequire()
        }
        self.loadData()
    }
    
    private func loadData() {
        self.viewModel.getBookingHistories(accessToken: UserSessionManager.shared.getAccessToken() ?? "") {
            self.segmentedControl.selectedSegmentIndex = 0
            self.reloadData()
        }
        self.refreshControl.endRefreshing()
    }
    
    // MARK: Config UI
    private func configUI() {
        configAppearance()
        
        view.addSubview(topView)
        configTopView()
        
        view.addSubview(bookingTableViewContainer)
        configBookingTableViewContainer()
        
        view.addSubview(blurView)
        view.addSubview(popupView)
        configPopupView()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemBackground
    }
    
    private func configTopView() {
        NSLayoutConstraint.activate([
            self.topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            self.topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-60)),
            self.topView.heightAnchor.constraint(equalToConstant: sizeScaler(230))
        ])
        
        topView.addSubview(viewTitle)
        configViewTitle()
        
        topView.addSubview(segmentedControl)
        configSegmentedControl()
    }
    
    private func configViewTitle() {
        self.viewTitle.setupTitle(text: "My Bookings", fontName: FontNames.avenir, size: sizeScaler(40), textColor: .customBlack)
        self.viewTitle.setBoldText()
        self.viewTitle.textAlignment = .left
        NSLayoutConstraint.activate([
            self.viewTitle.topAnchor.constraint(equalTo: topView.topAnchor, constant: heightScaler(30)),
            self.viewTitle.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            self.viewTitle.trailingAnchor.constraint(equalTo: topView.trailingAnchor)
        ])
    }
    
    private func configSegmentedControl() {
        NSLayoutConstraint.activate([
            self.segmentedControl.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            self.segmentedControl.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            self.segmentedControl.bottomAnchor.constraint(equalTo: topView.bottomAnchor),
            self.segmentedControl.heightAnchor.constraint(equalToConstant: heightScaler(50))
        ])
    }
    
    private func configBookingTableViewContainer() {
        NSLayoutConstraint.activate([
            self.bookingTableViewContainer.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: heightScaler(30)),
            self.bookingTableViewContainer.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            self.bookingTableViewContainer.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            self.bookingTableViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: heightScaler(-160)),
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
            self.bookingTableView.bottomAnchor.constraint(equalTo: bookingTableViewContainer.bottomAnchor, constant: heightScaler(-15)),
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
    
    
    // MARK: Setup Action
    private func setupAction() {
        self.segmentedControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        blurView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Catch Action
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
        
        self.reloadData()
    }
    
    @objc
    private func pullToRefresh() {
        self.refreshControl.beginRefreshing()
        DispatchQueue.main.async {
            self.loadData()
        }
    }
    
    @objc
    func dismissPopup() {
        UIView.animate(withDuration: 0.3) {
            self.popupView.alpha = 0
            self.blurView.alpha = 0
        }
    }
    
    // MARK: Utilities
    private func reloadData() {
        DispatchQueue.main.async {
            self.bookingTableView.reloadData()
        }
    }
    
    private func generateMenuList(bookingDetails: BookingDetail) {
        let itemList = bookingDetails.itemResponseList
        var menuDetails: String = ""
        
        if let seatName = bookingDetails.seatName,
           let areaName = bookingDetails.areaName {
            menuDetails += "Your table is booked:\n" + seatName + " in " + areaName + "\n\n" + "Your food has been ordered:\n"
        }
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
    
    private func cancelBookingTapped(indexPath: IndexPath) {
        self.displayRemind(title: "Confirm", message: "Are you sure you want to cancel your booking?", indexPath: indexPath)
    }
    
    private func cancelBooking(indexPath: IndexPath) {
        if let bookingId = self.viewModel.currentList?[indexPath.row].bookingId {
            self.viewModel.cancelBooking(bookingId: bookingId, accessToken: UserSessionManager.shared.getAccessToken() ?? "")
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.displayArlet(title: "Error", message: error.localizedDescription)
                    }
                } receiveValue: { success in
                    self.displayArlet(title: "Success", message: "Your booking has been placed by Cancelled\nApologize for the service quality")
                    self.loadData()
                }
                .store(in: &cancellables)
        }
    }
    
    private func displayArlet(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.dismiss(animated: true)
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func displayRemind(title: String, message: String, indexPath: IndexPath) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.cancelBooking(indexPath: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { action in
            self.dismiss(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func displayLoginRequire() {
        let alertController = UIAlertController(title: "Not Login", message: "Please login to see your profile", preferredStyle: .alert)
        
        let loginAction = UIAlertAction(title: "Login", style: .default) { action in
            let homeViewController = TransitionViewController()
            let navigationController = UINavigationController(rootViewController: homeViewController)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = windowScene.windows.first
                window?.rootViewController = navigationController
                window?.makeKeyAndVisible()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { action in
            self.dismiss(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(loginAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension BookingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.currentList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingHistoryTableViewCell.identifier, for: indexPath) as? BookingHistoryTableViewCell else {
            return UITableViewCell()
        }
        
        if let bookingDetail = self.viewModel.currentList?[indexPath.row] {
            cell.configure(bookingDetail: bookingDetail)
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

extension BookingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bookingList = self.viewModel.currentList {
            let bookingDetails = bookingList[indexPath.row]
            self.generateMenuList(bookingDetails: bookingDetails)
            showPopupView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightScaler(160)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if segmentedControl.selectedSegmentIndex == 2 || segmentedControl.selectedSegmentIndex == 1 {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Cancel") { _, _, completionHandler in
            self.cancelBookingTapped(indexPath: indexPath)
            completionHandler(true)
        }
        let image = UIImage(systemName: "trash.fill")?.withTintColor(.customPink, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(40), height: heightScaler(45)))
        deleteAction.image = image
        deleteAction.backgroundColor = .systemBackground
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

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
    var viewModel: StaffAccountViewModelProtocol = StaffAccountViewModel()
    
    // -MARK: Create UI Components
    lazy var header = makeView()
    lazy var headerLabel = makeLabel()
    lazy var coffeeAnimationView = makeLottieAnimationView(animationName: "coffee")
    lazy var accountImageButton = makeImageView(imageName: "person.circle", size: CGSize(width: sizeScaler(60), height: sizeScaler(60)))
    
    lazy var segmentedControl: UISegmentedControl = {
        var segment = UISegmentedControl(items: segmenItems)
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    lazy var bookingTableViewContainer = makeView()
    lazy var bookingTableView = makeTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        setupAction()
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
        
        view.addSubview(segmentedControl)
        configSegmentedControl()
        
        view.addSubview(bookingTableViewContainer)
        configBookingTableViewContainer()
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
        
        header.addSubview(accountImageButton)
        configAccountImageButton()
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
        if let username = UserSessionManager.shared.authenticationResponse?.accountResponse?.username {
            headerLabel.setupTitle(text: "Hello \(String(describing: username))!", fontName: FontNames.avenir, size: sizeScaler(45), textColor: .customBlack)
        } else {
            headerLabel.setupTitle(text: "Hello!", fontName: FontNames.avenir, size: sizeScaler(45), textColor: .customBlack)
        }
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: coffeeAnimationView.trailingAnchor, constant: sizeScaler(20)),
            headerLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor)
        ])
    }
    
    private func configAccountImageButton() {
        accountImageButton.image = accountImageButton.image?.withRenderingMode(.alwaysTemplate)
        accountImageButton.tintColor = .customBlack
        NSLayoutConstraint.activate([
            accountImageButton.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            accountImageButton.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
    }
    
    private func configSegmentedControl() {
        NSLayoutConstraint.activate([
            self.segmentedControl.topAnchor.constraint(equalTo: header.bottomAnchor, constant: heightScaler(30)),
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
    }
    
    // -MARK: Setup Data
    private func setupData() {
    }
    
    // -MARK: Setup Action
    private func setupAction() {
        let accountImageButtonGesture = UITapGestureRecognizer(target: self, action: #selector(accountImageButtonTapped))
        self.accountImageButton.addGestureRecognizer(accountImageButtonGesture)
        self.accountImageButton.isUserInteractionEnabled = true
        
        self.segmentedControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
    }
    
    // -MARK: Catch Action
    @objc
    private func accountImageButtonTapped() {
        let navigationController = UINavigationController(rootViewController: ProfileViewController())
        self.present(navigationController, animated: true)
    }
    
    @objc
    private func segmentValueChanged(_ sender: UISegmentedControl) {
        let selectedSegment = sender.selectedSegmentIndex
        
        switch selectedSegment {
        case 0:
            print("PENDING")
            //            self.viewModel.updateCurrentList(currentStatus: .pending)
        case 1:
            print("CONFIRMED")
            //            self.viewModel.updateCurrentList(currentStatus: .confirmed)
        case 2:
            print("CANCELLED")
            //            self.viewModel.updateCurrentList(currentStatus: .cancelled)
        default:
            print("No segment is selected")
        }
        
        //        reloadData()
    }
    
    // -MARK: Utilities
    private func displayErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func cancelBookingTapped(indexPath: IndexPath) {
        self.displayRemind(title: "Confirm", message: "Are you sure you want to cancel this booking?", indexPath: indexPath)
    }
    
    private func cancelBooking(indexPath: IndexPath) {
        //        if let bookingId = self.viewModel.currentList?[indexPath.row].bookingId {
        //            self.viewModel.cancelBooking(bookingId: bookingId, accessToken: UserSessionManager.shared.getAccessToken() ?? "")
        //                .sink { [weak self] completion in
        //                    switch completion {
        //                    case .finished:
        //                        break
        //                    case .failure(let error):
        //                        self?.displayArlet(title: "Error", message: error.localizedDescription)
        //                    }
        //                } receiveValue: { success in
        //                    self.displayArlet(title: "Success", message: "Your booking has been placed by Cancelled\nApologize for the service quality")
        //                    self.loadData()
        //                }
        //                .store(in: &cancellables)
        //        }
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
}

extension BookingManagerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        self.viewModel.currentList?.count ?? 0
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingHistoryTableViewCell.identifier, for: indexPath) as? BookingHistoryTableViewCell else {
            return UITableViewCell()
        }
        
        //        if let bookingDetail = self.viewModel.currentList?[indexPath.row] {
        //            cell.configure(bookingDetail: bookingDetail)
        //        }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}

extension BookingManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightScaler(160)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if segmentedControl.selectedSegmentIndex == 0 {
            let confirmAction = UIContextualAction(style: .normal, title: "Confirm") { _, _, completionHandler in
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
                completionHandler(true)
            }
            let image = UIImage(systemName: "xmark.seal")?.withTintColor(.systemPurple, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(40), height: heightScaler(40)))
            refuseAction.image = image
            refuseAction.backgroundColor = .systemTeal
            return UISwipeActionsConfiguration(actions: [refuseAction])
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
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


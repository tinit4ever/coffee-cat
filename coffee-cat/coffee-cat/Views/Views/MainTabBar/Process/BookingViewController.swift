//
//  BookingViewController.swift
//  coffee-cat
//
//  Created by Tin on 31/01/2024.
//

import UIKit

class BookingViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    let segmenItems = ["PENDING", "CONFIRMED", "CANCELLED"]
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    // MARK: Config UI
    private func configUI() {
        configAppearance()
        
        view.addSubview(topView)
        configTopView()
        
        view.addSubview(bookingTableViewContainer)
        configBookingTableViewContainer()
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
    }
}

extension BookingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookingHistoryTableViewCell.identifier, for: indexPath) as? BookingHistoryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

extension BookingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightScaler(160)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            completionHandler(true)
        }
        let image = UIImage(systemName: "trash.fill")?.withTintColor(.customPink, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(40), height: heightScaler(45)))
        deleteAction.image = image
        deleteAction.backgroundColor = .systemBackground
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

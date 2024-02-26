//
//  ShopDetailsViewController.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import UIKit
import SwiftUI
import Combine

class ShopDetailsViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: ShopDetailsViewModelProtocol = ShopDetailsViewModel()
    
    // MARK: - Create UIComponents
    lazy var overallImageView = makeImageView()
    lazy var indexLabel = makeLabel()
    
    lazy var shopInforStackView = makeVerticalStackView()
    lazy var shopNameLabel = makeLabel()
    lazy var starRatingView: StarRatingView = {
        let starRatingView = StarRatingView()
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        return starRatingView
    }()
    lazy var shopAddressLabel = makeLabel()
    lazy var phoneLabel = makeLabel()
    lazy var openTimeLabel = makeLabel()
    lazy var closeTimeLabel = makeLabel()
    
    lazy var orderTableButton = makeButton()
    
    lazy var orderFoodButton = makeButton()
    
    lazy var bookingButton: UIButton = makeButton()
    
    lazy var scrollView = makeScrollViewContainer()
    lazy var contentView = makeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configNavigation()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemGray5
        updateImage(index: self.viewModel.index)
        updateIndexLabel()
        
        configTopViews()
        
        view.addSubview(scrollView)
        configScrollView()
        
        scrollView.addSubview(shopInforStackView)
        configShopInforStackView()
        
        scrollView.addSubview(bookingButton)
        configBookingButton()
    }
    
    private func setupData() {
        self.viewModel.shop.name = "Coffee Shop"
        self.viewModel.shop.address = "Pham Van Dong"
        self.viewModel.shop.phone = "0318249849"
        self.viewModel.shop.rating = 3.4
        self.viewModel.shop.openTime = "8 AM"
        self.viewModel.shop.closeTime = "8 PM"
        
        self.orderTableButton.setTitle(title: "Select Table", fontName: FontNames.avenir, size: sizeScaler(24), color: .customBlack)
        self.orderTableButton.cornerRadius(cornerRadius: sizeScaler(22))
        self.orderTableButton.backgroundColor = .customPink
        
        self.orderFoodButton.setTitle(title: "Order Food", fontName: FontNames.avenir, size: sizeScaler(24), color: .customBlack)
        self.orderFoodButton.cornerRadius(cornerRadius: sizeScaler(22))
        self.orderFoodButton.backgroundColor = .customPink
        
        self.viewModel.shop.seatList = [
            "Good 1",
            "Good 2",
            "Good 3",
            "Good 4",
            "Good 5",
            "Good 6",
            "Good 7",
            "Good 1",
            "Good 2",
            "Good 3",
            "Good 4",
            "Good 5",
            "Good 6",
            "Good 7",
            "Good 1",
            "Good 2",
            "Good 3",
            "Good 4",
            "Good 5",
            "Good 6",
            "Good 7"
        ]
        
        self.viewModel.shop.commentList = [
            "Good",
            "Good",
            "Good",
            "Good",
            "Good",
            "Good",
            "Good"
        ]
        self.viewModel.index = 0
        self.viewModel.shop.shopImageList = ["1", "2", "3", "4"]
        
        loadData()
    }
    
    private func loadData() {
        self.shopNameLabel.text = self.viewModel.shop.name
        self.starRatingView.rating = self.viewModel.shop.rating ?? 0
        self.phoneLabel.text = "Phone: \(self.viewModel.shop.phone ?? "Unknown")"
        self.shopAddressLabel.text = "Address: \(self.viewModel.shop.address ?? "Unknown")"
        self.openTimeLabel.text = "Open Time: \(self.viewModel.shop.openTime ?? "Unknown")"
        self.closeTimeLabel.text = "Close Time: \(self.viewModel.shop.closeTime ?? "Unknown")"
    }
    
    private func configNavigation() {
        self.navigationItem.title = self.viewModel.shop.name
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func configTopViews() {
        view.addSubview(overallImageView)
        configOverallImageView()
        
        view.addSubview(indexLabel)
        configIndexLabel()
    }
    
    private func configOverallImageView() {
        overallImageView.contentMode = .scaleToFill
        NSLayoutConstraint.activate([
            overallImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            overallImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overallImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overallImageView.heightAnchor.constraint(equalToConstant: heightScaler(300)),
        ])
    }
    
    private func configIndexLabel() {
        indexLabel.textColor = .systemBackground
        indexLabel.backgroundColor = .systemGray
        indexLabel.layer.cornerRadius = sizeScaler(10)
        indexLabel.layer.masksToBounds = true
        indexLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            indexLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indexLabel.bottomAnchor.constraint(equalTo: overallImageView.bottomAnchor, constant: -heightScaler(10)),
            indexLabel.widthAnchor.constraint(equalToConstant: widthScaler(100))
        ])
    }
    
    private func configScrollView() {
        self.scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: overallImageView.bottomAnchor, constant: heightScaler(10)),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    private func configShopInforStackView() {
        shopInforStackView.alignment = .leading
        shopInforStackView.spacing = heightScaler(20)
        
        NSLayoutConstraint.activate([
            shopInforStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: heightScaler(20)),
            shopInforStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: widthScaler(60)),
            shopInforStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -widthScaler(60)),
        ])
        
        shopInforStackView.addArrangedSubview(shopNameLabel)
        shopNameLabel.font = UIFont(name: FontNames.avenir, size: sizeScaler(35))
        shopNameLabel.setBoldText()
        NSLayoutConstraint.activate([
            shopNameLabel.heightAnchor.constraint(equalToConstant: heightScaler(28))
        ])
        
        shopInforStackView.addArrangedSubview(starRatingView)
        NSLayoutConstraint.activate([
            starRatingView.heightAnchor.constraint(equalToConstant: heightScaler(28))
        ])
        
        shopInforStackView.addArrangedSubview(phoneLabel)
        phoneLabel.font = UIFont(name: FontNames.avenir, size: sizeScaler(28))
        NSLayoutConstraint.activate([
            phoneLabel.heightAnchor.constraint(equalToConstant: heightScaler(28))
        ])
        
        shopInforStackView.addArrangedSubview(shopAddressLabel)
        shopAddressLabel.font = UIFont(name: FontNames.avenir, size: sizeScaler(28))
        NSLayoutConstraint.activate([
            shopAddressLabel.heightAnchor.constraint(equalToConstant: heightScaler(28))
        ])
        
        shopInforStackView.addArrangedSubview(openTimeLabel)
        openTimeLabel.font = UIFont(name: FontNames.avenir, size: sizeScaler(28))
        NSLayoutConstraint.activate([
            openTimeLabel.heightAnchor.constraint(equalToConstant: heightScaler(28))
        ])
        
        shopInforStackView.addArrangedSubview(closeTimeLabel)
        closeTimeLabel.font = UIFont(name: FontNames.avenir, size: sizeScaler(28))
        NSLayoutConstraint.activate([
            closeTimeLabel.heightAnchor.constraint(equalToConstant: heightScaler(28))
        ])
        
        
        shopInforStackView.addArrangedSubview(orderTableButton)
        NSLayoutConstraint.activate([
            orderTableButton.heightAnchor.constraint(equalToConstant: heightScaler(38))
        ])
        
        shopInforStackView.addArrangedSubview(orderFoodButton)
        NSLayoutConstraint.activate([
            orderFoodButton.heightAnchor.constraint(equalToConstant: heightScaler(38))
        ])
    }
    
    private func configBookingButton() {
        bookingButton.cornerRadius(cornerRadius: heightScaler(30))
        bookingButton.setTitle(title: "Book", fontName: FontNames.avenir, size: sizeScaler(40), color: .systemGray5)
        bookingButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            bookingButton.topAnchor.constraint(equalTo: shopInforStackView.bottomAnchor, constant: heightScaler(600)),
            bookingButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthScaler(60)),
            bookingButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthScaler(60)),
            bookingButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -heightScaler(20)),
            bookingButton.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        setupSwipeGesture()
        orderTableButton.addTarget(self, action: #selector(orderTableButtonTapped), for: .touchUpInside)
        bookingButton.addTarget(self, action: #selector(bookingButtonTapped), for: .touchUpInside)
    }
    
    private func setupSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeLeft.direction = .left
        overallImageView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeRight.direction = .right
        overallImageView.addGestureRecognizer(swipeRight)
        
        overallImageView.isUserInteractionEnabled = true
    }
    
    // MARK: - Catch Action
    @objc private func swipeAction(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if self.viewModel.index == self.viewModel.shop.shopImageList.count - 1 {
                return
            }
            self.viewModel.swipeLeft()
            updateImage(index: self.viewModel.index)
            updateIndexLabel()
        } else if gesture.direction == .right {
            if self.viewModel.index == 0 {
                return
            }
            self.viewModel.swipeRight()
            updateImage(index: self.viewModel.index)
            updateIndexLabel()
        }
    }
    
    @objc private func orderTableButtonTapped() {
        let selectedTableViewController = SelectTableViewController()
        selectedTableViewController.seatList = self.viewModel.shop.seatList ?? []
        let navigationController = UINavigationController(rootViewController: selectedTableViewController)
        self.present(navigationController, animated: true, completion: nil)
        
        selectedTableViewController.didSendData = { [weak self] selectedTable in
            guard let self = self else { return }
            self.orderTableButton.setTitle("\(selectedTable)", for: .normal)
//                        self.viewModel.shop.seatList = selectedTable
        }
    }
    
    @objc private func bookingButtonTapped() {
        
    }
    // MARK: - Utilities
    private func updateImage(index: Int) {
        UIView.transition(with: overallImageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.overallImageView.image = UIImage(named: self.viewModel.shop.shopImageList[index])
        }, completion: nil)
    }
    
    private func updateIndexLabel() {
        let totalElements = self.viewModel.shop.shopImageList.count
        indexLabel.text = "\(self.viewModel.index + 1)/\(totalElements)"
    }
}

extension ShopDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeatCollectionViewCell.identifier, for: indexPath) as? SeatCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}
extension ShopDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// -MARK: Preview
struct ShopDetailsViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let shopDetailsViewController = ShopDetailsViewController()
            return shopDetailsViewController
        }
    }
}

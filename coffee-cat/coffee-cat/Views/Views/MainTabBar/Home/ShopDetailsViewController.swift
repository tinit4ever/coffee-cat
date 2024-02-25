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
    
    lazy var selectTableStack = makeHorizontalStackView()
    lazy var selectTableLabel = makeLabel()
    lazy var selectTableButton = makeButton()
    
    
    private lazy var bookingButton: UIButton = makeButton()
    
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
        view.addSubview(shopInforStackView)
        configShopInforStackView()
        
        view.addSubview(bookingButton)
        configBookingButton()
    }
    
    private func setupData() {
        self.viewModel.shop.name = "Coffee Shop"
        self.viewModel.shop.address = "Pham Van Dong"
        self.viewModel.shop.phone = "0318249849"
        self.viewModel.shop.rating = 3.4
        self.viewModel.shop.openTime = "8 AM"
        self.viewModel.shop.closeTime = "8 PM"
        
        self.selectTableButton.setTitle(title: "Select Table", fontName: FontNames.avenir, size: sizeScaler(24), color: .customBlack)
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
        self.shopAddressLabel.text = self.viewModel.shop.address
        self.phoneLabel.text = self.viewModel.shop.phone
        self.openTimeLabel.text = self.viewModel.shop.openTime
        self.closeTimeLabel.text = self.viewModel.shop.closeTime
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
    
    private func configShopInforStackView() {
        shopInforStackView.alignment = .leading
        shopInforStackView.spacing = heightScaler(20)
        
        NSLayoutConstraint.activate([
            shopInforStackView.topAnchor.constraint(equalTo: overallImageView.bottomAnchor, constant: heightScaler(20)),
            shopInforStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: widthScaler(60)),
            shopInforStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -widthScaler(60)),
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
        
        
        shopInforStackView.addArrangedSubview(selectTableStack)
        NSLayoutConstraint.activate([
            selectTableStack.heightAnchor.constraint(equalToConstant: heightScaler(38))
        ])
        selectTableStack.addArrangedSubview(selectTableLabel)
        selectTableStack.addArrangedSubview(selectTableButton)
        selectTableStack.distribution = .fill
        selectTableStack.alignment = .center
        selectTableStack.spacing = widthScaler(10)
        selectTableStack.widthAnchor.constraint(equalTo: shopInforStackView.widthAnchor).isActive = true
        
        selectTableLabel.text = "Select Table"
        NSLayoutConstraint.activate([
            selectTableLabel.heightAnchor.constraint(equalTo: selectTableButton.heightAnchor),
            selectTableLabel.widthAnchor.constraint(equalToConstant: widthScaler(280))
        ])
        selectTableLabel.layer.cornerRadius = sizeScaler(10)
        selectTableLabel.layer.masksToBounds = true
        selectTableLabel.textAlignment = .center
        selectTableLabel.backgroundColor = .customPink.withAlphaComponent(0.5)
    }
    
    private func configBookingButton() {
        bookingButton.cornerRadius(cornerRadius: heightScaler(30))
        bookingButton.setTitle(title: "Book", fontName: FontNames.avenir, size: sizeScaler(40), color: .systemGray5)
        bookingButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            bookingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            bookingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
            bookingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -heightScaler(20)),
            bookingButton.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        setupSwipeGesture()
        selectTableButton.addTarget(self, action: #selector(selectTableButtonTapped), for: .touchUpInside)
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
    
    @objc private func selectTableButtonTapped() {
        let selectedTableViewController = SelectTableViewController()
        selectedTableViewController.seatList = self.viewModel.shop.seatList ?? []
        let navigationController = UINavigationController(rootViewController: selectedTableViewController)
        self.present(navigationController, animated: true, completion: nil)
        
        selectedTableViewController.didSendData = { [weak self] selectedTable in
            guard let self = self else { return }
            self.selectTableButton.setTitle("\(selectedTable)", for: .normal)
            //            self.viewModel.shop.seatList = selectedTable
        }
    }
    
    @objc private func bookingButtonTapped() {
        
    }
    // MARK: - Utilities
    private func updateImage(index: Int) {
        UIView.transition(with: overallImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
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

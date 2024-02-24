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
    lazy var seatListLabel = makeLabel()
    lazy var openTimeLabel = makeLabel()
    lazy var closeTimeLabel = makeLabel()
    
    lazy var seatListCollectionView = makeCollectionView(space: sizeScaler(20), size: CGSize(width: heightScaler(110), height: heightScaler(110)))
    
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
        
        view.addSubview(seatListCollectionView)
        view.addSubview(bookingButton)
        
        configBookingButton()
        configSeatListCollectionView()
    }
    
    private func setupData() {
        self.viewModel.shop.name = "Coffee Shop"
        self.viewModel.shop.address = "Pham Van Dong"
        self.viewModel.shop.rating = 3.4
        self.viewModel.shop.openTime = "8 AM"
        self.viewModel.shop.closeTime = "8 PM"
        
        self.seatListLabel.text = "Table List"
        self.viewModel.shop.seatList = [
            "Good",
            "Good",
            "Good",
            "Good",
            "Good",
            "Good",
            "Good"
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
        self.openTimeLabel.text = self.viewModel.shop.openTime
        self.closeTimeLabel.text = self.viewModel.shop.closeTime
    }
    
    private func setupAction() {
        setupSwipeGesture()
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
        shopInforStackView.spacing = heightScaler(12)
        
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
        
        shopInforStackView.addArrangedSubview(shopAddressLabel)
        shopAddressLabel.font = UIFont(name: FontNames.avenir, size: sizeScaler(28))
        NSLayoutConstraint.activate([
            shopAddressLabel.heightAnchor.constraint(equalToConstant: heightScaler(28))
        ])
        
        shopInforStackView.addArrangedSubview(seatListLabel)
        seatListLabel.font = UIFont(name: FontNames.avenir, size: sizeScaler(32))
        seatListLabel.setBoldText()
        NSLayoutConstraint.activate([
            seatListLabel.heightAnchor.constraint(equalToConstant: heightScaler(32))
        ])
    }
    
    private func configSeatListCollectionView() {
        seatListCollectionView.delegate = self
        seatListCollectionView.dataSource = self
        seatListCollectionView.register(SeatCollectionViewCell.self, forCellWithReuseIdentifier: SeatCollectionViewCell.identifier)
        
        seatListCollectionView.layer.cornerRadius = sizeScaler(20)
        NSLayoutConstraint.activate([
            seatListCollectionView.topAnchor.constraint(equalTo: shopInforStackView.bottomAnchor, constant: heightScaler(10)),
            seatListCollectionView.leadingAnchor.constraint(equalTo: shopInforStackView.leadingAnchor),
            seatListCollectionView.trailingAnchor.constraint(equalTo: shopInforStackView.trailingAnchor),
            seatListCollectionView.bottomAnchor.constraint(equalTo: bookingButton.topAnchor, constant: -heightScaler(20))
        ])
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

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
    
    lazy var bookingOptionStack = makeHorizontalStackView()
    lazy var chooseTableButton = makeButton()
    lazy var orderFoodButton = makeButton()
    
    lazy var viewCatListButton = makeButton()
    
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
        self.chooseTableButton.cornerRadius(cornerRadius: sizeScaler(15))
        self.chooseTableButton.backgroundColor = .customPink
        self.chooseTableButton.setTitle(title: "Choose Table", fontName: FontNames.avenir, size: sizeScaler(24), color: .customBlack)
        
        self.orderFoodButton.setTitle(title: "Order Food", fontName: FontNames.avenir, size: sizeScaler(24), color: .customBlack)
        self.orderFoodButton.cornerRadius(cornerRadius: sizeScaler(15))
        self.orderFoodButton.backgroundColor = .customPink
        
        self.viewCatListButton.setTitle(title: "Cat List", fontName: FontNames.avenir, size: sizeScaler(30), color: .customBlack)
        self.viewCatListButton.cornerRadius(cornerRadius: sizeScaler(15))
        self.viewCatListButton.backgroundColor = .systemBrown
        
        self.viewModel.shop?.commentList = [
            "Good",
            "Good",
            "Good",
            "Good",
            "Good",
            "Good",
            "Good"
        ]
        
        self.viewModel.index = 0
        self.viewModel.shop?.shopImageList = ["1", "2", "3", "4"]
        loadData()
    }
    
    private func loadData() {
        self.shopNameLabel.text = self.viewModel.shop?.name
        self.starRatingView.rating = self.viewModel.shop?.rating ?? 0
        self.phoneLabel.text = "Phone: \(self.viewModel.shop?.phone ?? "Unknown")"
        self.shopAddressLabel.text = "Address: \(self.viewModel.shop?.address ?? "Unknown")"
        self.openTimeLabel.text = "Open Time: \(self.viewModel.shop?.openTime ?? "Unknown")"
        self.closeTimeLabel.text = "Close Time: \(self.viewModel.shop?.closeTime ?? "Unknown")"
    }
    
    private func configNavigation() {
        self.navigationItem.title = self.viewModel.shop?.name
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
        
        
        shopInforStackView.addArrangedSubview(bookingOptionStack)
        bookingOptionStack.distribution = .fillEqually
        bookingOptionStack.spacing = widthScaler(60)
        bookingOptionStack.heightAnchor.constraint(equalToConstant: heightScaler(45)).isActive = true
        bookingOptionStack.widthAnchor.constraint(equalTo: shopInforStackView.widthAnchor).isActive = true
        bookingOptionStack.addArrangedSubview(chooseTableButton)
        bookingOptionStack.addArrangedSubview(orderFoodButton)
        
        shopInforStackView.addArrangedSubview(viewCatListButton)
        viewCatListButton.heightAnchor.constraint(equalToConstant: heightScaler(60)).isActive = true
        viewCatListButton.widthAnchor.constraint(equalTo: shopInforStackView.widthAnchor).isActive = true
    }
    
    private func configBookingButton() {
        bookingButton.cornerRadius(cornerRadius: heightScaler(30))
        bookingButton.setTitle(title: "Book", fontName: FontNames.avenir, size: sizeScaler(40), color: .systemGray5)
        bookingButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            bookingButton.topAnchor.constraint(equalTo: shopInforStackView.bottomAnchor, constant: heightScaler(600)),
            bookingButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthScaler(60)),
            bookingButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthScaler(60)),
            bookingButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -heightScaler(60)),
            bookingButton.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        setupSwipeGesture()
        chooseTableButton.addTarget(self, action: #selector(chooseTableButtonTapped), for: .touchUpInside)
        orderFoodButton.addTarget(self, action: #selector(orderFoodButtonTapped), for: .touchUpInside)
        viewCatListButton.addTarget(self, action: #selector(viewCatListButtonTapped), for: .touchUpInside)
        
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
    @objc 
    private func swipeAction(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if self.viewModel.index == self.viewModel.shop?.shopImageList.count ?? 0 - 1 {
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
    
    @objc 
    private func chooseTableButtonTapped() {
        let selectedTableViewController = SelectTableViewController()
        selectedTableViewController.areaList = self.viewModel.areaList ?? []
        let navigationController = UINavigationController(rootViewController: selectedTableViewController)
        self.present(navigationController, animated: true, completion: nil)
        
        selectedTableViewController.didSelectSeat = { [weak self] selectedSeat in
            if selectedSeat != nil {
                self?.chooseTableButton.setTitle("Selected Table", for: .normal)
            } else {
                self?.chooseTableButton.setTitle("Choose Table", for: .normal)
            }
        }
    }
    
    @objc
    private func orderFoodButtonTapped() {
        let orderFoodViewController = OrderFoodViewController()
        orderFoodViewController.menuList = self.viewModel.shop?.menuItemList ?? []
        let navigationController = UINavigationController(rootViewController: orderFoodViewController)
        self.present(navigationController, animated: true, completion: nil)
        
        orderFoodViewController.didSelectFood = { [weak self] menuBookingList in
            
        }
    }
    
    @objc
    private func viewCatListButtonTapped() {
        let catListViewController = CatListViewController()
//        catListViewController.areaList = self.viewModel.shop?.areaList ?? []
        let navigationController = UINavigationController(rootViewController: catListViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func bookingButtonTapped() {
        print("Tapped1")
        
    }
    
    // MARK: - Utilities
    private func updateImage(index: Int) {
        UIView.transition(with: overallImageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.overallImageView.image = UIImage(named: self.viewModel.shop?.shopImageList[index] ?? "")
        }, completion: nil)
    }
    
    private func updateIndexLabel() {
        let totalElements = self.viewModel.shop?.shopImageList.count
        indexLabel.text = "\(self.viewModel.index + 1)/\(String(describing: totalElements))"
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

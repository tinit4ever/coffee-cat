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
    lazy var scrollViewContainer = makeScrollViewContainer()
    
    lazy var overallImageView = makeImageView()
    lazy var indexLabel = makeLabel()
    
    lazy var shopNameLabel = makeLabel()
    lazy var shopAddressLabel = makeLabel()
    lazy var starRatingView: StarRatingView = {
        let starRatingView = StarRatingView()
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        return starRatingView
    }()
    lazy var openTimeLabel = makeLabel()
    lazy var closeTimeLabel = makeLabel()
    
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
//        view.backgroundColor = .white
        
        updateImage(index: self.viewModel.index)
        updateIndexLabel()
        
        view.addSubview(scrollViewContainer)
        configScrollViewContainter()
        configSubViews()
    }
    
    private func setupData() {
//        self.viewModel.shop.name = "Coffee Shop"
//        self.viewModel.shop.address = "Pham Van Dong"
//        self.viewModel.shop.rating = 3.4
//        self.viewModel.shop.openTime = "8 AM"
//        self.viewModel.shop.closeTime = "8 PM"
//        self.viewModel.shop.commentList = [
//            "Good",
//            "Good",
//            "Good",
//            "Good",
//            "Good",
//            "Good",
//            "Good"
//        ]
        self.viewModel.index = 0
        self.viewModel.shop.shopImageList = ["1", "2", "3", "4"]
    }
    
    private func setupAction() {
        setupSwipeGesture()
    }
    
    private func configNavigation() {
        self.navigationItem.title = self.viewModel.shop.name
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func configScrollViewContainter() {
        NSLayoutConstraint.activate([
            scrollViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollViewContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollViewContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configSubViews() {
        scrollViewContainer.addSubview(overallImageView)
        configOverallImageView()
        
        scrollViewContainer.addSubview(indexLabel)
        configIndexLabel()
    }
    
    private func configOverallImageView() {
        overallImageView.backgroundColor = .systemBackground
        overallImageView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            overallImageView.topAnchor.constraint(equalTo: scrollViewContainer.topAnchor),
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

// -MARK: Preview
struct ShopDetailsViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let shopDetailsViewController = ShopDetailsViewController()
            return shopDetailsViewController
        }
    }
}

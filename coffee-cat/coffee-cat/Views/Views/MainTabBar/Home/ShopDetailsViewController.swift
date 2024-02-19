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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        setupAction()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemGray5
        configNavigation()
        
        updateImage(index: self.viewModel.index)
        updateIndexLabel()
        
        view.addSubview(overallImageView)
        configOverallImageView()
        
        view.addSubview(indexLabel)
        configIndexLabel()
    }
    
    private func setupData() {
        self.viewModel.imageList = ["person", "trash", "house", "circle"]
        self.viewModel.index = 0
    }
    
    private func setupAction() {
        setupSwipeGesture()
    }
    
    private func configNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .backButton
    }
    
    private func configOverallImageView() {
        overallImageView.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            overallImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            overallImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            overallImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
            self.viewModel.swipeLeft()
        } else if gesture.direction == .right {
            self.viewModel.swipeRight()
        }
        
        updateImage(index: self.viewModel.index)
        updateIndexLabel()
    }
    
    // MARK: - Utilities
    private func updateImage(index: Int) {
        overallImageView.image = UIImage(systemName: self.viewModel.imageList[index])
    }
    
    private func updateIndexLabel() {
        let totalElements = self.viewModel.imageList.count
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


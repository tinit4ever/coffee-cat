//
//  ShopManagerViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 27/02/2024.
//

import UIKit

class ShopManagerViewController: UIViewController, ShopManagerFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    // -MARK: Create UI Components
    lazy var editShopProfileButton = makeButton()
    
    lazy var animationView = makeLottieAnimationView(animationName: "shop-manager")
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        configUI()
        setupAction()
    }
    
    // -MARK: Config UI
    private func configUI() {
        view.backgroundColor = .animationBackground
        
        view.addSubview(editShopProfileButton)
        configEditShopProfileButton()
        
        view.addSubview(animationView)
        animationView.play()
        configAnimationView()
        
        view.addSubview(shopInforStackView)
        configShopInforStackView()
    }
    
    private func configEditShopProfileButton() {
        let buttonImage = UIImage(systemName: "square.and.pencil")?.withTintColor(.systemPurple, renderingMode: .alwaysOriginal).resized(to: CGSize(width: widthScaler(80), height: widthScaler(80)))
        
        editShopProfileButton.setImage(buttonImage, for: .normal)
        NSLayoutConstraint.activate([
            editShopProfileButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: heightScaler(10)),
            editShopProfileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-40))
            
        ])
    }
    
    private func configAnimationView() {
        animationView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: heightScaler(30)),
            animationView.widthAnchor.constraint(equalToConstant: sizeScaler(400)),
            animationView.heightAnchor.constraint(equalToConstant: sizeScaler(400)),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configShopInforStackView() {
        shopInforStackView.alignment = .leading
        shopInforStackView.spacing = heightScaler(40)
        
        NSLayoutConstraint.activate([
            shopInforStackView.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: heightScaler(70)),
            shopInforStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            shopInforStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
        ])
        
        shopInforStackView.addArrangedSubview(shopNameLabel)
        shopNameLabel.textColor = .black
        shopNameLabel.font = UIFont(name: FontNames.avenir, size: sizeScaler(42))
        shopNameLabel.setBoldText()
        NSLayoutConstraint.activate([
            shopNameLabel.heightAnchor.constraint(equalToConstant: heightScaler(34))
        ])
        
        shopInforStackView.addArrangedSubview(starRatingView)
        NSLayoutConstraint.activate([
            starRatingView.heightAnchor.constraint(equalToConstant: heightScaler(36))
        ])
        
        shopInforStackView.addArrangedSubview(phoneLabel)
        phoneLabel.font = UIFont(name: FontNames.avenir, size: sizeScaler(30))
        phoneLabel.textColor = .black
        NSLayoutConstraint.activate([
            phoneLabel.heightAnchor.constraint(equalToConstant: heightScaler(30))
        ])
        
        shopInforStackView.addArrangedSubview(shopAddressLabel)
        shopAddressLabel.font = UIFont(name: FontNames.avenir, size: sizeScaler(30))
        shopAddressLabel.textColor = .black
        NSLayoutConstraint.activate([
            shopAddressLabel.heightAnchor.constraint(equalToConstant: heightScaler(30))
        ])
        
        shopInforStackView.addArrangedSubview(openTimeLabel)
        openTimeLabel.font = UIFont(name: FontNames.avenir, size: sizeScaler(30))
        openTimeLabel.textColor = .black
        NSLayoutConstraint.activate([
            openTimeLabel.heightAnchor.constraint(equalToConstant: heightScaler(30))
        ])
        
        shopInforStackView.addArrangedSubview(closeTimeLabel)
        closeTimeLabel.font = UIFont(name: FontNames.avenir, size: sizeScaler(30))
        closeTimeLabel.textColor = .black
        NSLayoutConstraint.activate([
            closeTimeLabel.heightAnchor.constraint(equalToConstant: heightScaler(30))
        ])
    }
    
    // -MARK: Setup Data
    private func setupData() {
        self.shopNameLabel.text = "Ca phe buoi sang"
        self.starRatingView.rating = 4
        self.phoneLabel.text = "Phone: 0358887710"
        self.shopAddressLabel.text = "Address: 20 Pham Van Dong"
        self.openTimeLabel.text = "Open Time: 7:00 AM"
        self.closeTimeLabel.text = "Close Time: 7:00 PM"
    }
    
    // -MARK: Setup Action
    private func setupAction() {
        self.editShopProfileButton.addTarget(self, action: #selector(editShopProfileButtonTapped), for: .touchUpInside)
    }
    
    
    // -MARK: Catch Action
    @objc
    private func editShopProfileButtonTapped() {
        let viewController = EditShopDetailsViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
}

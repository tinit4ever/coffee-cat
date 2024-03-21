//
//  ShopManagerViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 27/02/2024.
//

import UIKit
import Combine

class ShopManagerViewController: UIViewController, ShopManagerFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: ShopManagerViewModelProtocol = ShopManagerViewModel()
    var cancellables: Set<AnyCancellable> = []
    
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
        setupAsync()
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
            shopInforStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(40)),
            shopInforStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(30)),
        ])
        
        shopInforStackView.addArrangedSubview(shopNameLabel)
        shopNameLabel.textColor = .black
        shopNameLabel.font = UIFont(name: FontNames.avenir, size: sizeScaler(42))
        shopNameLabel.setBoldText()
        NSLayoutConstraint.activate([
            shopNameLabel.heightAnchor.constraint(equalToConstant: heightScaler(34))
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
            shopAddressLabel.heightAnchor.constraint(equalToConstant: heightScaler(60))
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
    
    // -MARK: Setup Async
    private func setupAsync() {
        self.viewModel.isGetShopInforSuccessSubject
            .sink { result in
                switch result {
                case .success():
                    self.loadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
    // -MARK: Setup Data
    private func setupData() {
        self.viewModel.getShopInfor()
    }
    
    // -MARK: Load Data
    private func loadData() {
        guard let shopInfor = viewModel.shopInfor else {
            return
        }
        
        self.shopNameLabel.text = shopInfor.name
        self.phoneLabel.text = "Phone: \(shopInfor.phone)"
        self.shopAddressLabel.text = "Address: \(shopInfor.address)"
        self.openTimeLabel.text = "Open Time: \(shopInfor.openTime)"
        self.closeTimeLabel.text = "Close Time: \(shopInfor.closeTime)"
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
        
        viewController.didUpdateSuccess = {
            self.setupData()
        }
    }
}

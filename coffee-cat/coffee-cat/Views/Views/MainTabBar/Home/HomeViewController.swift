//
//  HomeViewController.swift
//  coffee-cat
//
//  Created by Tin on 31/01/2024.
//

import UIKit
import SwiftUI
import Alamofire

class HomeViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    let viewModel: HomeViewModelProtocol = HomeViewModel()
    var tableViewTitle: String = "Top Results"
    
    // -MARK: Create UI Components
    lazy var topView = makeView()
    lazy var topViewLabel = makeLabel()
    lazy var coffeeAnimationView = makeLottieAnimationView(animationName: "coffee")
    lazy var accountImageButton = makeImageView(imageName: "person.circle", size: CGSize(width: sizeScaler(60), height: sizeScaler(60)))
    
    lazy var hookLabel = makeLabel()
    
    lazy var searchBar = makeSearchBar(placeholder: "Search")
    
    lazy var shopListContainer = makeView()
    lazy var shopList = makeTableView()
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    // -MARK: SetupData
    private func setupData() {
        self.viewModel.getShopList {
            DispatchQueue.main.async {
                self.shopList.reloadData()
            }
        }
    }
    
    // -MARK: SetupUI
    private func setupUI() {
        configAppearance()
        configNavigation()
        
        view.addSubview(topView)
        configTopView()
        
        view.addSubview(hookLabel)
        configHookLabel()
        
        view.addSubview(searchBar)
        configSearchBar()
        
//        view.addSubview(shopList)
        view.addSubview(shopListContainer)
        configShopList()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray5
    }
    
    private func configNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .backButton
    }
    
    private func configTopView() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: heightScaler(10)),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
            topView.heightAnchor.constraint(equalToConstant: sizeScaler(80))
        ])
        
        topView.addSubview(coffeeAnimationView)
        coffeeAnimationView.play()
        configCoffeeAnimationView()
        
        topView.addSubview(topViewLabel)
        configTopViewLabel()
        
        topView.addSubview(accountImageButton)
        configAccountImageButton()
    }
    
    private func configCoffeeAnimationView() {
        coffeeAnimationView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            coffeeAnimationView.leadingAnchor.constraint(equalTo: topView.leadingAnchor),
            coffeeAnimationView.widthAnchor.constraint(equalToConstant: sizeScaler(60)),
            coffeeAnimationView.heightAnchor.constraint(equalTo: topView.heightAnchor),
            coffeeAnimationView.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
        ])
    }
    
    private func configTopViewLabel() {
        topViewLabel.setupTitle(text: "Hello!", fontName: FontNames.avenir, size: sizeScaler(45), textColor: .customBlack)
        NSLayoutConstraint.activate([
            topViewLabel.leadingAnchor.constraint(equalTo: coffeeAnimationView.trailingAnchor, constant: sizeScaler(20)),
            topViewLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor)
        ])
    }
    
    private func configAccountImageButton() {
        accountImageButton.image = accountImageButton.image?.withRenderingMode(.alwaysTemplate)
        accountImageButton.tintColor = .customBlack
        NSLayoutConstraint.activate([
            accountImageButton.trailingAnchor.constraint(equalTo: topView.trailingAnchor),
            accountImageButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor)
        ])
    }
    
    private func configHookLabel() {
        hookLabel.setupTitle(text: "It's A Great Day For Coffee Cat", fontName: FontNames.avenir, size: sizeScaler(45), textColor: .customBlack)
        hookLabel.setBoldText()
        hookLabel.numberOfLines = 0
        hookLabel.lineBreakMode = .byWordWrapping
        hookLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            hookLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: heightScaler(20)),
            hookLabel.leadingAnchor.constraint(equalTo: coffeeAnimationView.leadingAnchor),
            hookLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 3 * 2),
            hookLabel.heightAnchor.constraint(equalToConstant: sizeScaler(125))
        ])
    }
    
    private func configSearchBar() {
        searchBar.delegate = self
        searchBar.backgroundColor = .systemBackground
        searchBar.layer.cornerRadius = sizeScaler(40)
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.borderStyle = .none
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: hookLabel.bottomAnchor, constant: heightScaler(20)),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
            searchBar.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    private func configShopList() {
        shopList.delegate = self
        shopList.dataSource = self
        shopList.register(ShopTableViewCell.self, forCellReuseIdentifier: ShopTableViewCell.identifier)
        
        shopListContainer.layer.cornerRadius = sizeScaler(10)
        shopListContainer.layer.masksToBounds = true
        shopListContainer.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            shopListContainer.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: heightScaler(30)),
            shopListContainer.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            shopListContainer.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            shopListContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -heightScaler(160))
        ])
        
        shopListContainer.addSubview(shopList)
        shopList.separatorStyle = .none
        NSLayoutConstraint.activate([
            shopList.topAnchor.constraint(equalTo: shopListContainer.topAnchor),
            shopList.leadingAnchor.constraint(equalTo: shopListContainer.leadingAnchor),
            shopList.trailingAnchor.constraint(equalTo: shopListContainer.trailingAnchor),
            shopList.bottomAnchor.constraint(equalTo: shopListContainer.bottomAnchor, constant: -heightScaler(15))
        ])
    }
    
    // -MARK: Push View
    private func pushToShopDetails(shopId: Int) {
        let shopDetailsViewController = ShopDetailsViewController()
        self.navigationController?.pushViewController(shopDetailsViewController, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate {
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToShopDetails(shopId: 1)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.shopList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopTableViewCell.identifier, for: indexPath) as! ShopTableViewCell
        
        let shop = self.viewModel.shopList[indexPath.row]
        
        cell.configure(shop: shop)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightScaler(140)
    }
}

// -MARK: Preview
struct HomeViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let homeViewController = HomeViewController()
            return homeViewController
        }
    }
}

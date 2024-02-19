//
//  HomeViewController.swift
//  coffee-cat
//
//  Created by Tin on 31/01/2024.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    var tableViewTitle: String = "Top Results"
    
    // -MARK: Create UI Components
    lazy var topView = makeView()
    lazy var topViewLabel = makeLabel()
    lazy var coffeeAnimationView = makeLottieAnimationView(animationName: "coffee")
    lazy var accountImageButton = makeImageView(imageName: "person.circle", size: CGSize(width: sizeScaler(60), height: sizeScaler(60)))
    
    lazy var hookLabel = makeLabel()
    
    lazy var searchBar = makeSearchBar(placeholder: "Search")
    
    lazy var shopList = makeTableView()
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        
        view.addSubview(shopList)
        configShopList()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray5
    }
    
    private func configNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let backImage = UIImage(systemName: "chevron.backward.circle.fill")?
            .withTintColor(.backButton, renderingMode: .alwaysOriginal)
            .resized(to: CGSize(width: sizeScaler(50), height: sizeScaler(50)))
        
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
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
        shopList.register(UITableViewCell.self, forCellReuseIdentifier: "titleCell")
        view.addSubview(shopList)
        shopList.layer.cornerRadius = sizeScaler(10)
        NSLayoutConstraint.activate([
            shopList.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: heightScaler(30)),
            shopList.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            shopList.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            shopList.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -heightScaler(160))
        ])
    }
}

extension HomeViewController: UISearchBarDelegate {
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let firstCell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
            firstCell.textLabel?.text = self.tableViewTitle
            firstCell.textLabel?.font = UIFont(name: FontNames.avenir, size: sizeScaler(30))
            firstCell.textLabel?.setBoldText()
            return firstCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShopTableViewCell.identifier, for: indexPath) as! ShopTableViewCell
            cell.configure(imageName: "coffee", shopName: "The Coffee House", rating: 3)
            return cell
        }
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

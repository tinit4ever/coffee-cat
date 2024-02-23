//
//  HomeViewController.swift
//  coffee-cat
//
//  Created by Tin on 31/01/2024.
//

import UIKit
import SwiftUI
import Alamofire

enum SortOrder {
    case ascending
    case descending
}

enum SortBy {
    case name
    case rating
    case address
}

enum SearchBy {
    case name
    case address
}

enum Menu {
    case sortBy
    case sortOrder
    case searchBy
}

class HomeViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    var viewModel: HomeViewModelProtocol = HomeViewModel()
    var inSearchMode = false
    
    var menu: [UIMenu] = []
    
    // -MARK: Create UI Components
    lazy var topView = makeView()
    lazy var topViewLabel = makeLabel()
    lazy var coffeeAnimationView = makeLottieAnimationView(animationName: "coffee")
    lazy var accountImageButton = makeImageView(imageName: "person.circle", size: CGSize(width: sizeScaler(60), height: sizeScaler(60)))
    
    lazy var hookLabel = makeLabel()
    
    lazy var searchBar = makeSearchBar(placeholder: "Search")
    
    private let sortButton: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.gray()
        configuration.title = "Sort"
        configuration.image = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        configuration.imagePadding = 4
        configuration.imagePlacement = .trailing
        configuration.baseBackgroundColor = .systemGray5
        
        button.configuration = configuration
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchBy: UIButton = {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.gray()
        configuration.title = "Search By"
        configuration.image = UIImage(systemName: "line.3.horizontal.decrease.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        configuration.imagePadding = 4
        configuration.imagePlacement = .trailing
        configuration.baseBackgroundColor = .systemGray5
        
        button.configuration = configuration
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var shopListContainer = makeView()
    lazy var shopList = makeTableView()
    
    lazy var loadingAnimationView = makeLottieAnimationView(animationName: "loading")
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigation()
        setupData()
    }
    
    // -MARK: SetupData
    private func setupData() {
        reloadShopListData()
    }
    
    // -MARK: SetupUI
    private func setupUI() {
        configAppearance()
        
        view.addSubview(topView)
        configTopView()
        
        view.addSubview(hookLabel)
        configHookLabel()
        
        view.addSubview(searchBar)
        configSearchBar()
        
        view.addSubview(sortButton)
        configSortButton()
        
        view.addSubview(searchBy)
        configSearchBy()
        
        view.addSubview(shopListContainer)
        configShopList()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray3
    }
    
    private func configNavigation() {
        let backImage = UIImage(systemName: "chevron.backward.circle.fill")?
            .withTintColor(.customPink, renderingMode: .alwaysOriginal)
        
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .backButton
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func configTopView() {
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
            topView.heightAnchor.constraint(equalToConstant: sizeScaler(80)),
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
        //        hookLabel.backgroundColor = .red
        hookLabel.setupTitle(text: "It's A Great Day For Coffee Cat", fontName: FontNames.avenir, size: sizeScaler(35), textColor: .customBlack)
        hookLabel.setBoldText()
        hookLabel.numberOfLines = 0
        hookLabel.lineBreakMode = .byWordWrapping
        hookLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            hookLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: heightScaler(20)),
            hookLabel.leadingAnchor.constraint(equalTo: coffeeAnimationView.leadingAnchor),
            hookLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 3 * 2),
            //            hookLabel.heightAnchor.constraint(equalToConstant: sizeScaler(105))
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
    
    private func configSortButton() {
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: heightScaler(20)),
            sortButton.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
        ])
        
        menu = [createSortByMenu(.rating), createSortOrderMenu(.descending)]
        sortButton.menu = UIMenu(children: menu)
        sortButton.showsMenuAsPrimaryAction = true
        sortButton.setTitle(title: "Sort", fontName: FontNames.avenir, size: sizeScaler(24), color: .systemGray)
    }
    
    private func configSearchBy() {
        searchBy.menu = UIMenu(children: [createSearchByMenu(.name)])
        searchBy.showsMenuAsPrimaryAction = true
        searchBy.setTitle(title: "Search By", fontName: FontNames.avenir, size: sizeScaler(24), color: .systemGray)
        NSLayoutConstraint.activate([
            searchBy.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: heightScaler(20)),
            searchBy.leadingAnchor.constraint(equalTo: sortButton.trailingAnchor, constant: widthScaler(20)),
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
            shopListContainer.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: heightScaler(10)),
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
        
        shopListContainer.addSubview(loadingAnimationView)
        configLoadingView()
    }
    
    private func configLoadingView() {
        loadingAnimationView.isHidden = true
        NSLayoutConstraint.activate([
            loadingAnimationView.widthAnchor.constraint(equalToConstant: sizeScaler(300)),
            loadingAnimationView.heightAnchor.constraint(equalToConstant: sizeScaler(300)),
            loadingAnimationView.centerXAnchor.constraint(equalTo: shopListContainer.centerXAnchor),
            loadingAnimationView.centerYAnchor.constraint(equalTo: shopListContainer.centerYAnchor)
        ])
    }
    
    // -MARK: Push View
    private func pushToShopDetails(shop: Shop) {
        let shopDetailsViewController = ShopDetailsViewController()
        shopDetailsViewController.viewModel.shop = shop
        self.navigationController?.pushViewController(shopDetailsViewController, animated: true)
    }
    
    // -MARK: Utilities
    private func createSortOrderMenu(_ on: SortOrder) -> UIMenu {
        let sortOrderClosure = { (action: UIAction) in
            self.updateSortMenu(on: .sortOrder, with: action.title)
        }
        
        let sortOrder = UIMenu(title: "Sort Order", options: .displayInline, children: [
            UIAction(title: "Ascending", image: UIImage(systemName: "arrow.up"), handler:
                        sortOrderClosure),
            UIAction(title: "Descending", image: UIImage(systemName: "arrow.down"),  handler: sortOrderClosure),
        ])
        switch on {
        case .ascending:
            (sortOrder.children[0] as! UIAction).state = .on
        case .descending:
            (sortOrder.children[1] as! UIAction).state = .on
        }
        
        return sortOrder
    }
    
    private func createSortByMenu(_ on: SortBy) -> UIMenu {
        let sortByClosure = { (action: UIAction) in
            self.updateSortMenu(on: .sortBy, with: action.title)
        }
        let sortBy = UIMenu(title: "Sort By", options: .displayInline, children: [
            UIAction(title: "Name", image: UIImage(systemName: "person.text.rectangle"), handler:
                        sortByClosure),
            UIAction(title: "Rating", image: UIImage(systemName: "star"), handler: sortByClosure),
            UIAction(title: "Address", image: UIImage(systemName: "house"),  handler: sortByClosure),
        ])
        
        switch on {
        case .name:
            (sortBy.children[0] as! UIAction).state = .on
        case .rating:
            (sortBy.children[1] as! UIAction).state = .on
        case .address:
            (sortBy.children[2] as! UIAction).state = .on
        }
        
        return sortBy
    }
    
    private func updateSortMenu(on menu: Menu, with title: String) {
        switch menu {
        case .sortBy:
            if title == "Name" {
                self.menu[0] = createSortByMenu(.name)
            } else if title == "Rating" {
                self.menu[0] = createSortByMenu(.rating)
            } else if title == "Address" {
                self.menu[0] = createSortByMenu(.address)
            }
        case .sortOrder:
            if title == "Ascending" {
                self.menu[1] = createSortOrderMenu(.ascending)
            } else if title == "Descending" {
                self.menu[1] = createSortOrderMenu(.descending)
            }
        case .searchBy:
            print("NA")
        }
        self.sortButton.menu = UIMenu(children: self.menu)
        self.updateSearchResutl(on: menu, with: title)
    }
    
    private func createSearchByMenu(_ on: SearchBy) -> UIMenu {
        let searchByClosure = { (action: UIAction) in
            self.updateSearchByMenu(on: .searchBy, with: action.title)
        }
        
        var searchBy = UIMenu()
        switch on {
        case .name:
            searchBy = UIMenu(title: "Search By", options: .displayInline, children: [
                UIAction(title: "Name", image: UIImage(systemName: "person.text.rectangle"), state: .on, handler:
                            searchByClosure),
                UIAction(title: "Address", image: UIImage(systemName: "house"),  handler: searchByClosure),
            ])
        case .address:
            searchBy = UIMenu(title: "Search By", options: .displayInline, children: [
                UIAction(title: "Name", image: UIImage(systemName: "person.text.rectangle"), handler:
                            searchByClosure),
                UIAction(title: "Address", image: UIImage(systemName: "house"), state: .on, handler: searchByClosure),
            ])
        }
        
        return searchBy
    }
    
    private func updateSearchByMenu(on menu: Menu, with title: String) {
        if title == "Name" {
            self.searchBy.menu = UIMenu(children: [createSearchByMenu(.name)])
        } else if title == "Address" {
            self.searchBy.menu = UIMenu(children: [createSearchByMenu(.address)])
        }
        
        self.updateSearchResutl(on: menu, with: title)
    }
    
    private func updateSearchResutl(on: Menu, with title: String) {
        switch on {
        case .searchBy:
            if title == "Name" {
                self.viewModel.searchParam.searchType = "name"
            } else if title == "Address" {
                self.viewModel.searchParam.searchType = "address"
            }
            
        case .sortBy:
            if title == "Name" {
                self.viewModel.searchParam.sortBy = "name"
            } else if title == "Rating" {
                self.viewModel.searchParam.sortBy = "rating"
            } else if title == "Address" {
                self.viewModel.searchParam.sortBy = "address"
            }
        case .sortOrder:
            if title == "Ascending" {
                self.viewModel.searchParam.asc = true
            } else if title == "Descending" {
                self.viewModel.searchParam.asc = false
            }
        }
        
        self.search()
    }
    
    private func search() {
        if let searchText = self.searchBar.text {
            if searchText.isEmpty {
                self.viewModel.tableViewTitle = "Top Results"
            } else {
                self.viewModel.tableViewTitle = "Result for \"\(searchText)\""
            }
            self.viewModel.setSearchText(searchText)
        }
        
        reloadShopListData()
        
    }
    
    private func showLoadingView() {
        self.loadingAnimationView.isHidden = false
        self.loadingAnimationView.play()
    }
    
    private func hiddenLoadingView() {
        self.loadingAnimationView.isHidden = true
        self.loadingAnimationView.stop()
        self.view.isUserInteractionEnabled = true
    }
    
    private func reloadShopListData() {
        showLoadingView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.shopList.reloadData()
            self.hiddenLoadingView()
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.inSearchMode = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.search()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.inSearchMode = false
        self.search()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shop = self.viewModel.shopList[indexPath.row]
        pushToShopDetails(shop: shop)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.tableViewTitle
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
        return heightScaler(120)
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

//
//  MenuViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 03/03/2024.
//

import UIKit
import SwiftUI
import Combine

class MenuViewController: UIViewController, MenuFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var viewModel: MenuViewModelProtocol = MenuViewModel()
    var cancellables: Set<AnyCancellable> = []
    // MARK: - Create UIComponents
    lazy var managerStack = makeHorizontalStackView()
    lazy var deleteMenuItem = makeButton()
    lazy var updateMenuItem = makeButton()
    lazy var addMenuItem = makeButton()
    
    lazy var menuCollectionView = makeCollectionView(space: sizeScaler(30), size: CGSize(width: widthScaler(350), height: heightScaler(200)))
    
    lazy var popupView = makePopupView(frame: CGRect(x: widthScaler(80), y: heightScaler(140), width: widthScaler(500), height: heightScaler(175)))
    lazy var blurView = makeBlurView(frame: view.bounds, effect: UIBlurEffect(style: .systemMaterial))
    lazy var menuItemStack = makeVerticalStackView()
    lazy var menuItemNameTextField = makeTextFieldWithFrame(placeholder: "Enter name")
    lazy var menuItemPriceTextField = makeTextFieldWithFrame(placeholder: "Enter price")
    lazy var submitInputButton = makeButtonWithFrame()
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        setupData()
    }
    
    // -MARK: SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(managerStack)
        configManagerStack()
        
        view.addSubview(menuCollectionView)
        configMenuCollectionView()
        
        view.addSubview(blurView)
        view.addSubview(popupView)
        configPopupView()
    }
    
    private func configManagerStack() {
        managerStack.backgroundColor = .systemPurple
        managerStack.layer.cornerRadius = sizeScaler(10)
        managerStack.distribution = .equalCentering
        managerStack.layoutMargins = UIEdgeInsets(top: heightScaler(10), left: 30, bottom: heightScaler(10), right: 30)
        managerStack.isLayoutMarginsRelativeArrangement = true
        NSLayoutConstraint.activate([
            managerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: heightScaler(10)),
            managerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(30)),
            managerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-30))
        ])
        
        managerStack.addArrangedSubview(deleteMenuItem)
        deleteMenuItem.isEnabled = false
        deleteMenuItem.setImage(UIImage(systemName: "trash")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(30), height: heightScaler(35))), for: .normal)
        deleteMenuItem.setImage(UIImage(systemName: "trash")?.withTintColor(.systemGray2, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(30), height: heightScaler(35))), for: .disabled)
        
        managerStack.addArrangedSubview(updateMenuItem)
        updateMenuItem.isEnabled = false
        updateMenuItem.setImage(UIImage(systemName: "slider.vertical.3")?.withTintColor(.systemCyan, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(40), height: heightScaler(35))), for: .normal)
        
        updateMenuItem.setImage(UIImage(systemName: "slider.vertical.3")?.withTintColor(.systemGray2, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(40), height: heightScaler(35))), for: .disabled)
        
        managerStack.addArrangedSubview(addMenuItem)
        addMenuItem.setImage(UIImage(systemName: "plus")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(40), height: heightScaler(35))), for: .normal)
    }
    
    private func configMenuCollectionView() {
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.identifier)
        menuCollectionView.backgroundColor = .systemBlue
        menuCollectionView.layer.cornerRadius = sizeScaler(20)
        menuCollectionView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            menuCollectionView.topAnchor.constraint(equalTo: managerStack.bottomAnchor, constant: heightScaler(20)),
            menuCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(30)),
            menuCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthScaler(-30)),
            menuCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: heightScaler(-60))
        ])
        
    }
    
    private func configPopupView() {
        popupView.addSubview(menuItemNameTextField)
        let spacing = heightScaler(20)
        let height = heightScaler(34)
        
        menuItemNameTextField.frame = CGRect(x: widthScaler(40), y: heightScaler(20), width: popupView.frame.width - widthScaler(80), height: height)
        
        menuItemNameTextField.tintColor = .systemPurple
        menuItemNameTextField.layer.cornerRadius = sizeScaler(10)
        menuItemNameTextField.layer.borderWidth = widthScaler(3)
        menuItemNameTextField.layer.borderColor = UIColor.systemGray.cgColor
        let menuItemNameTextFieldPadding = makePaddingTextField(with: CGSize(width: widthScaler(20), height: menuItemNameTextField.frame.height))
        menuItemNameTextField.leftView = menuItemNameTextFieldPadding
        menuItemNameTextField.rightView = menuItemNameTextFieldPadding
        menuItemNameTextField.leftViewMode = .always
        menuItemNameTextField.rightViewMode = .always
        
        menuItemNameTextField.font = UIFont(name: FontNames.avenir, size: sizeScaler(22))
        
        popupView.addSubview(menuItemPriceTextField)
        menuItemPriceTextField.frame = CGRect(x: widthScaler(40), y: heightScaler(20) + spacing + height, width: popupView.frame.width - widthScaler(80), height: height)
        
        let menuItemPriceTextFieldPadding = makePaddingTextField(with: CGSize(width: widthScaler(20), height: menuItemNameTextField.frame.height))
        menuItemPriceTextField.tintColor = .systemPurple
        menuItemPriceTextField.layer.cornerRadius = sizeScaler(10)
        menuItemPriceTextField.layer.borderWidth = widthScaler(3)
        menuItemPriceTextField.layer.borderColor = UIColor.systemGray.cgColor
        menuItemPriceTextField.leftView = menuItemPriceTextFieldPadding
        menuItemPriceTextField.rightView = menuItemPriceTextFieldPadding
        menuItemPriceTextField.leftViewMode = .always
        menuItemPriceTextField.rightViewMode = .always
        
        menuItemPriceTextField.font = UIFont(name: FontNames.avenir, size: sizeScaler(22))
        menuItemPriceTextField.keyboardType = .numberPad
        
        popupView.addSubview(submitInputButton)
        submitInputButton.setTitle("Submit", for: .normal)
        submitInputButton.setFont(fontName: FontNames.avenir, size: sizeScaler(22))
        self.submitInputButton.setTitleColor(.black, for: .normal)
        submitInputButton.frame = CGRect(x: widthScaler(40), y: menuItemPriceTextField.frame.origin.y + spacing + height, width: widthScaler(180), height: heightScaler(24))
    }
    
    // -MARK: Setup Data
    private func setupData() {
        self.viewModel.getMenuList()
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        addMenuItem.addTarget(self, action: #selector(addMenuItemTapped), for: .touchUpInside)
        updateMenuItem.addTarget(self, action: #selector(updateMenuItemTapped), for: .touchUpInside)
        deleteMenuItem.addTarget(self, action: #selector(deleteMenuItemTapped), for: .touchUpInside)
        
        submitInputButton.addTarget(self, action: #selector(submitInputButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        blurView.addGestureRecognizer(tapGesture)
        
        setupAsync()
    }
    
    private func setupAsync() {
        self.viewModel.isGetDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success():
                    self.menuCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
      
        self.viewModel.isCreatedPublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success():
                    self.displaySuccess(message: "Item have been created")
                    self.dismissPopup()
                case .failure(let error):
                    self.displayFaild(message: "Error \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
        
        self.viewModel.isUpdatedPublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success():
                    self.displaySuccess(message: "Item have been updated")
                    self.dismissPopup()
                case .failure(let error):
                    self.displayFaild(message: "Error \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
        
        self.viewModel.isDeleteSuccessPublisher
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .success():
                    self.displaySuccess(message: "Item have been deleted")
                case .failure(let error):
                    self.displayFaild(message: "Error: \(error.localizedDescription)")
                }
            }
            .store(in: &cancellables)
    }

    // -MARK: Catch Action
    @objc
    private func addMenuItemTapped() {
        self.submitInputButton.setTitle("Create", for: .normal)
        self.submitInputButton.setBackgroundColor(backgroundColor: .systemGreen)
        self.menuItemNameTextField.text = ""
        self.menuItemPriceTextField.text = ""
        UIView.animate(withDuration: 0.3) {
            self.popupView.alpha = 1 - self.popupView.alpha
            self.blurView.alpha = 1 - self.blurView.alpha
        }
    }
    
    @objc
    private func updateMenuItemTapped() {
        self.submitInputButton.setTitle("Update", for: .normal)
        self.submitInputButton.setBackgroundColor(backgroundColor: .systemBlue)
        self.viewModel.isUpdating = true
        self.menuItemNameTextField.text = self.viewModel.selectedMenuItem?.name
        if let price = self.viewModel.selectedMenuItem?.price {
            self.menuItemPriceTextField.text = String(describing: price)
        }
        UIView.animate(withDuration: 0.3) {
            self.popupView.alpha = 1 - self.popupView.alpha
            self.blurView.alpha = 1 - self.blurView.alpha
        }
    }
    
    @objc func deleteMenuItemTapped() {
        viewModel.deleteMenuItem()
    }
    
    @objc 
    func submitInputButtonTapped() {
        guard let name = menuItemNameTextField.text,
              let priceText = menuItemPriceTextField.text else {
            return
        }
        
        guard let price: Double = Double(priceText) else {
            self.displayFaild(message: "Price input is not available")
            return
        }
        
        if viewModel.isUpdating {
            guard let id: Int = viewModel.selectedMenuItem?.id else {
                return
            }
            
            viewModel.setSumitItem(id: id, name: name, price: price)
            viewModel.updateMenuItem()
        } else {
            viewModel.setSumitItem(id: -1, name: name, price: price)
            viewModel.createMenuItem()
        }
    }
    
    @objc 
    func dismissPopup() {
        UIView.animate(withDuration: 0.3) {
            self.popupView.alpha = 0
            self.blurView.alpha = 0
        }
        
        self.viewModel.isUpdating = false
        self.view.endEditing(true)
    }
    
    // -MARK: Utilities
    
    private func displayErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please order at least one food\nYou can close without submit by click close button", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func displaySuccess(message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func displayFaild(message: String) {
        let alertController = UIAlertController(title: "Faild", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier, for: indexPath) as? MenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let menuItem = self.viewModel.menu[indexPath.row]
        cell.configure(menuItem)
        
        return cell
    }
}
extension MenuViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deleteMenuItem.isEnabled = true
        updateMenuItem.isEnabled = true
        
        self.viewModel.setSelected(index: indexPath.row)
    }
}

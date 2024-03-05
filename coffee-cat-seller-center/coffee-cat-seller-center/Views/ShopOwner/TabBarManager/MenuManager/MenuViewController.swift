//
//  MenuViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 03/03/2024.
//

import UIKit
import SwiftUI

class MenuViewController: UIViewController, MenuFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var menuList: [MenuItem] = []
    
    // MARK: - Create UIComponents
    lazy var managerStack = makeHorizontalStackView()
    lazy var deleteMenuItem = makeButton()
    lazy var updateMenuItem = makeButton()
    lazy var addMenuItem = makeButton()
    
    lazy var menuCollectionView = makeCollectionView(space: sizeScaler(30), size: CGSize(width: widthScaler(350), height: heightScaler(200)))
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // -MARK: SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(managerStack)
        configManagerStack()
        
        view.addSubview(menuCollectionView)
        configMenuCollectionView()
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
        deleteMenuItem.setImage(UIImage(systemName: "trash")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(30), height: heightScaler(35))), for: .normal)
        
        managerStack.addArrangedSubview(updateMenuItem)
        updateMenuItem.setImage(UIImage(systemName: "slider.vertical.3")?.withTintColor(.systemCyan, renderingMode: .alwaysOriginal).resized(to: CGSize(width: heightScaler(40), height: heightScaler(35))), for: .normal)
//        managerStack.addArrangedSubview(a)
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
    
    // -MARK: setupData
    
    // MARK: - Setup Action

    // -MARK: Catch Action
    
    // -MARK: Utilities
    
    private func displayErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please order at least one food\nYou can close without submit by click close button", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier, for: indexPath) as? MenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        
//        let menuItem = self.menuList[indexPath.row]
//        cell.configure(menuItem)
        
        return cell
    }
}
extension MenuViewController: UICollectionViewDelegate {
}

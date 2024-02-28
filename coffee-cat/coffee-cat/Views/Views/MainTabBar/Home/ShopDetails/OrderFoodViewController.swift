//
//  OrderFoodViewController.swift
//  coffee-cat
//
//  Created by Tin on 28/02/2024.
//

import UIKit
import SwiftUI

class OrderFoodViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var menuList: [MenuItem] = []
    
    var menuBookingList: [MenuBooking] = []
    var selectedCell: MenuCollectionViewCell?
    var didSelectFood: (([MenuBooking]) -> Void)?
    
    // MARK: - Create UIComponents
    lazy var stepper: UIStepper = {
        let stepper = UIStepper(frame: .zero)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    lazy var menuCollectionView = makeCollectionView(space: sizeScaler(40), size: CGSize(width: widthScaler(400), height: heightScaler(300)))
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        setupAction()
    }
    
    // -MARK: SetupUI
    private func setupUI() {
        view.backgroundColor = .systemMint
        configNavigation()
        
        view.addSubview(menuCollectionView)
        configMenuCollectionView()
    }
    
    private func configNavigation() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelButtonTapped))
        
        let stepperButton = UIBarButtonItem(customView: stepper)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = widthScaler(100)
        
        doneButton.tintColor = .customPink
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItems = [doneButton, space, stepperButton]
        
        configStepperButton()
    }
    
    private func configStepperButton() {
        stepper.minimumValue = 0
        stepper.maximumValue = 10
        stepper.stepValue = 1
        stepper.isEnabled = false
    }
    
    private func configMenuCollectionView() {
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: MenuCollectionViewCell.identifier)
        
        NSLayoutConstraint.activate([
            menuCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            menuCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // -MARK: setupData
    private func setupData() {
        for menu in menuList {
            let menuBooking = MenuBooking(itemID: menu.id ?? 0, quantity: 0)
            self.menuBookingList.append(menuBooking)
        }
    }
    
    // MARK: - Setup Action
    private func setupAction() {
        self.stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    // -MARK: Catch Action
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        menuBookingList = menuBookingList.filter { $0.quantity > 0 }
        if menuBookingList.isEmpty {
            setupData()
        } else {
            self.didSelectFood?(menuBookingList)
        }
    }
    
    @objc 
    func stepperValueChanged(_ sender: UIStepper) {
        guard let selectedCell = selectedCell else {
            return
        }
        
        selectedCell.quantity = Int(sender.value)
        self.updateQuantity(forItemID: selectedCell.id ?? 0, newQuantity: selectedCell.quantity)
    }
    
    // -MARK: Utilities
    private func updateQuantity(forItemID itemID: Int, newQuantity: Int) {
        for index in 0..<self.menuBookingList.count {
            if menuBookingList[index].itemID == itemID {
                menuBookingList[index].quantity = newQuantity
                break
            }
        }
    }
}

extension OrderFoodViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier, for: indexPath) as? MenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let menuItem = self.menuList[indexPath.row]
        cell.configure(menuItem)
        
        return cell
    }
}
extension OrderFoodViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.stepper.isEnabled = true
        guard let cell = collectionView.cellForItem(at: indexPath) as? MenuCollectionViewCell else {
            return
        }
        selectedCell = cell
        stepper.value = Double(cell.quantity)
    }
}

// -MARK: Preview
struct OrderFoodViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let orderFoodViewController = OrderFoodViewController()
            return orderFoodViewController
        }
    }
}

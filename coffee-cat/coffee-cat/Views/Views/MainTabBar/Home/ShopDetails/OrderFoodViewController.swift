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
    // MARK: - Setup Action
    private func setupAction() {
        self.stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)

    }
    
    // -MARK: Catch Action
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        //        if let selectedTable = self.selectedTable {
        //            didSendData?(selectedTable)
        //        }
        self.dismiss(animated: true)
    }
    
    @objc 
    func stepperValueChanged(_ sender: UIStepper) {
        print(Int(sender.value))
    }

}

extension OrderFoodViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return seatList.count
        28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier, for: indexPath) as? MenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        //        cell.configure(self.seatList[indexPath.row])
        
        return cell
    }
}
extension OrderFoodViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        self.selectedTable = self.seatList[indexPath.row]
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

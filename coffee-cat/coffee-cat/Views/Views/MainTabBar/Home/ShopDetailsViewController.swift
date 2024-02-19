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
    
    var imageList = ["person", "trash", "house", "circle"] {
        didSet {
            updateImage()
            updateIndexLabel()
        }
    }
    
    var index = 0 {
        didSet {
            updateImage()
            updateIndexLabel()
        }
    }
    
    // MARK: - Create UIComponents
    lazy var overallImageView = makeImageView()
    
    let indexLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        setupSwipeGesture()
        updateImage()
        updateIndexLabel()
        
        view.addSubview(overallImageView)
        
        NSLayoutConstraint.activate([
            overallImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            overallImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            overallImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            overallImageView.heightAnchor.constraint(equalToConstant: heightScaler(300)),
        ])
        
        overallImageView.backgroundColor = .white
        view.addSubview(indexLabel)
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
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemGray6
        configNavigation()
    }
    
    private func configNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .backButton
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
        if gesture.direction == .left && index < imageList.count - 1 {
            index += 1
        } else if gesture.direction == .right && index > 0 {
            index -= 1
        }
        
        updateImage()
    }
    
    // MARK: - Utilities
    private func updateImage() {
        overallImageView.image = UIImage(systemName: imageList[index])
    }
    
    private func updateIndexLabel() {
        let totalElements = imageList.count
        indexLabel.text = "\(index + 1)/\(totalElements)"
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


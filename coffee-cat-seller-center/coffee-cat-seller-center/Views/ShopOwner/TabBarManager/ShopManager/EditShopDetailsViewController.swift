//
//  EditShopDetailsViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 06/03/2024.
//

import UIKit

class EditShopDetailsViewController: UIViewController, ShopManagerFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    // MARK: - Create UI Components
    lazy var animationView = makeLottieAnimationView(animationName: "custom")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    
    // MARK: - Config UI
    private func configUI() {
        view.backgroundColor = .animationBackground
        
        cofigNavigation()
        
        view.addSubview(animationView)
        animationView.play()
        configAnimationView()
    }
    
    private func cofigNavigation() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelButtonTapped))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = .systemPurple
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configAnimationView() {
        animationView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: heightScaler(20)),
            animationView.widthAnchor.constraint(equalToConstant: sizeScaler(540)),
            animationView.heightAnchor.constraint(equalToConstant: sizeScaler(400)),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
        self.dismiss(animated: true)
    }
}

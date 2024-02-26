//
//  AdminViewController.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 26/02/2024.
//

import UIKit
import SwiftUI

class AdminViewController: UIViewController, AdminFactory  {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    // -MARK: Create UI Components
    lazy var topView = makeView()
    lazy var topViewLabel = makeLabel()
    lazy var coffeeAnimationView = makeLottieAnimationView(animationName: "coffee")
    lazy var accountImageButton = makeImageView(imageName: "person.circle", size: CGSize(width: sizeScaler(60), height: sizeScaler(60)))
    
    lazy var accountTableView = makeTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // -MARK: SetupUI
    private func setupUI() {
        self.view.backgroundColor = .systemMint.withAlphaComponent(0.8)
        
        view.addSubview(topView)
        configTopView()
        
        view.addSubview(accountTableView)
        configAccountTableView()
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
    
    private func configAccountTableView() {
        accountTableView.delegate = self
        accountTableView.dataSource = self
        accountTableView.register(AccountTableViewCell.self, forCellReuseIdentifier: AccountTableViewCell.identifier)
        
        accountTableView.layer.cornerRadius = sizeScaler(20)
        accountTableView.layer.masksToBounds = true
        accountTableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            accountTableView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: heightScaler(40)),
            accountTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(30)),
            accountTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(30)),
            accountTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -heightScaler(40)),
        ])
    }
}

extension AdminViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.identifier, for: indexPath) as? AccountTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightScaler(100)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Accounts"
    }
}

extension AdminViewController: UITableViewDelegate {
    
}

// -MARK: Preview
struct AdminViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let adminViewControllerPreview = AdminViewController()
            return adminViewControllerPreview
        }
    }
}


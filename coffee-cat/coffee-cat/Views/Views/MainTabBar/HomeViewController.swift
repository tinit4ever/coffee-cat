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
    
    // -MARK: Create UI Components
    lazy var coffeeAnimationView = makeLottieAnimationView(animationName: "coffee")

    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // -MARK: SetupUI
    private func setupUI() {
        configAppearance()
        configNavigation()
        
        view.addSubview(coffeeAnimationView)
        coffeeAnimationView.play()
        configCoffeeAnimationView()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray5
    }
    
    private func configNavigation() {
        let backImage = UIImage(systemName: "chevron.backward.circle.fill")?
            .withTintColor(.backButton, renderingMode: .alwaysOriginal)
            .resized(to: CGSize(width: sizeScaler(50), height: sizeScaler(50)))
        
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .backButton
    }
    
    private func configCoffeeAnimationView() {
//        coffeeAnimationView.backgroundColor = .red
        NSLayoutConstraint.activate([
            coffeeAnimationView.topAnchor.constraint(equalTo: view.topAnchor, constant: heightScaler(10)),
            coffeeAnimationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(10)),
            coffeeAnimationView.widthAnchor.constraint(equalToConstant: widthScaler(150)),
            coffeeAnimationView.heightAnchor.constraint(equalToConstant: heightScaler(90))
        ])
    }
}

// -MARK: Preview
struct HomeViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let homeViewControllerPreview = HomeViewController()
            return homeViewControllerPreview
        }
    }
}


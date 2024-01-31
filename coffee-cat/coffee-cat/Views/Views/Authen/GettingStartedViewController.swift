//
//  ViewController.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit
import SwiftUI

class GettingStartedViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    // -MARK: Create UI Components
    lazy var coffeeCatImageView: UIImageView = makeSquareImageView(imageName: ImageNames.coffeeCat, size: sizeScaler(250))
    
    private lazy var getStartedTitleLabel: UILabel = makeLabel()
    
    private lazy var getStartedContentLabel: UILabel = makeLabel()
    
    private lazy var getStartedButton: UIButton = makeButton()
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
    
    // -MARK: SetupUI
    
    func setupUI() {
        configAppearance()
        
        configNavigation()
        
        view.addSubview(coffeeCatImageView)
        configCoffeeCatImageView()
        
        view.addSubview(getStartedTitleLabel)
        configGetStartedTitleLabel()
        
        view.addSubview(getStartedContentLabel)
        configGetStartedContentLabel()
        
        view.addSubview(getStartedButton)
        configGetStartedButton()
    }
    
    func configAppearance() {
        view.backgroundColor = .systemGray5
        
        removeCircleGroupImageView()
        checkAndChangeAppearancceMode()
    }
    
    func removeCircleGroupImageView() {
        for subview in view.subviews {
            if let imageView = subview as? UIImageView,
               imageView.image == UIImage(named: ImageNames.darkCircleGroup) ||
                imageView.image == UIImage(named: ImageNames.lightCircleGroup)
            {
                imageView.removeFromSuperview()
            }
        }
    }

    func checkAndChangeAppearancceMode() {
        if traitCollection.userInterfaceStyle == .dark {
            let image = UIImage(named: ImageNames.darkCircleGroup)?.resized(to: CGSize(width: view.bounds.width / 1.5, height: view.bounds.width / 5))
            let imageView = UIImageView(image: image)
            view.addSubview(imageView)
        } else {
            let image = UIImage(named: ImageNames.lightCircleGroup)?.resized(to: CGSize(width: view.bounds.width / 1.5, height: view.bounds.height / 5))
            let imageView = UIImageView(image: image)
            view.addSubview(imageView)
        }
    }
    
    func configNavigation() {
        let backImage = UIImage(systemName: "chevron.backward.circle.fill")?
            .withTintColor(.backButton, renderingMode: .alwaysOriginal)
            .resized(to: CGSize(width: sizeScaler(50), height: sizeScaler(50)))

        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .backButton
    }

    func configCoffeeCatImageView() {
        NSLayoutConstraint.activate([
            coffeeCatImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 5),
            coffeeCatImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configGetStartedTitleLabel() {
        getStartedTitleLabel.setupTitle(text: GettingStartedScreenText.gettingStartedTitle, fontName: FontNames.avenir , size: sizeScaler(42), textColor: .customBlack)
        getStartedTitleLabel.setBoldText()
        coffeeCatImageView.contentMode = .scaleToFill
        NSLayoutConstraint.activate([
            getStartedTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStartedTitleLabel.topAnchor.constraint(equalTo: coffeeCatImageView.bottomAnchor, constant: heightScaler(20)),
            getStartedTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(30)),
            getStartedTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(30))
        ])
    }
    
    func configGetStartedContentLabel() {
        getStartedContentLabel.setupTitle(text: GettingStartedScreenText.getStartedContent, fontName: FontNames.avenir, size: sizeScaler(32), textColor: .customBlack)
        
        NSLayoutConstraint.activate([
            getStartedContentLabel.topAnchor.constraint(equalTo: getStartedTitleLabel.bottomAnchor, constant: heightScaler(30)),
            getStartedContentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(50)),
            getStartedContentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(50))
        ])
    }
    
    func configGetStartedButton() {
        getStartedButton.cornerRadius(cornerRadius: heightScaler(30))
        getStartedButton.setTitle(title: GettingStartedScreenText.getStartedButtonTitle, fontName: FontNames.avenir, size: sizeScaler(40), color: .systemGray5)
        getStartedButton.backgroundColor = .customPink
        
        NSLayoutConstraint.activate([
            getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(60)),
            getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(60)),
            getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -heightScaler(60)),
            getStartedButton.heightAnchor.constraint(equalToConstant: heightScaler(60))
        ])
    }
    
    // -MARK: Setup Action
    func setupAction() {
        getStartedButton.addTarget(self, action: #selector(getStartedButtonTapped), for: .touchUpInside)
    }
    
    // -MARK: Catch Action
    @objc
    func getStartedButtonTapped() {
        let signUpViewController = SignUpViewController()
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
}

// -MARK: Preview
struct GettingStartedViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let gettingStartedViewControllerPreview = GettingStartedViewController()
            return gettingStartedViewControllerPreview
        }
    }
}

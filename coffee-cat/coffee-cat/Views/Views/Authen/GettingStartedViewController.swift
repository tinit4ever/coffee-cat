//
//  ViewController.swift
//  coffee cat
//
//  Created by Tin on 16/01/2024.
//

import UIKit
import SwiftUI
import Lottie

class GettingStartedViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    // -MARK: Create UI Components
    lazy var animationView = makeLottieAnimationView(animationName: "cat-coffee")
    
    private lazy var getStartedTitleLabel: UILabel = makeLabel()
    
    private lazy var getStartedContentLabel: UILabel = makeLabel()
    
    private lazy var getStartedButton: UIButton = makeButton()
    
    // -MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
    
    // -MARK: Override
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            configAppearance()
        }
    }
    // -MARK: SetupUI
    
    private func setupUI() {
        configAppearance()
        
        configNavigation()
        
        view.addSubview(animationView)
        animationView.play()
        configAnimationView()
        
        view.addSubview(getStartedTitleLabel)
        configGetStartedTitleLabel()
        
        view.addSubview(getStartedContentLabel)
        configGetStartedContentLabel()
        
        view.addSubview(getStartedButton)
        configGetStartedButton()
    }
    
    private func configAppearance() {
        view.backgroundColor = .systemGray5
        
        removeCircleGroupImageView()
        checkAndChangeAppearancceMode()
    }
    
    private func removeCircleGroupImageView() {
        for subview in view.subviews {
            if let imageView = subview as? UIImageView,
               let imageName = imageView.image?.accessibilityIdentifier,
               (imageName == ImageNames.darkCircleGroup || imageName == ImageNames.lightCircleGroup)
            {
                imageView.removeFromSuperview()
            }
        }
    }
    
    private func checkAndChangeAppearancceMode() {
        if traitCollection.userInterfaceStyle == .dark {
            let image = UIImage(named: ImageNames.darkCircleGroup)
            image?.accessibilityIdentifier = ImageNames.darkCircleGroup

            let resizedImage = image?.resized(to: CGSize(width: widthScaler(700), height: heightScaler(200)))

            let imageView = UIImageView(image: resizedImage)
            imageView.image?.accessibilityIdentifier = ImageNames.darkCircleGroup

            view.addSubview(imageView)

        } else {
            let image = UIImage(named: ImageNames.darkCircleGroup)
            image?.accessibilityIdentifier = ImageNames.darkCircleGroup

            let resizedImage = image?.resized(to: CGSize(width: widthScaler(700), height: heightScaler(200)))

            let imageView = UIImageView(image: resizedImage)
            imageView.image?.accessibilityIdentifier = ImageNames.darkCircleGroup

            view.addSubview(imageView)

        }
    }
    
    private func configNavigation() {
        let backImage = UIImage(systemName: "chevron.backward.circle.fill")?
            .withTintColor(.backButton, renderingMode: .alwaysOriginal)
        
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .backButton
    }
    
    private func configAnimationView() {
        animationView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 5),
            animationView.widthAnchor.constraint(equalToConstant: sizeScaler(300)),
            animationView.heightAnchor.constraint(equalToConstant: sizeScaler(250)),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configGetStartedTitleLabel() {
        getStartedTitleLabel.setupTitle(text: GettingStartedScreenText.gettingStartedTitle, fontName: FontNames.avenir , size: sizeScaler(42), textColor: .customBlack)
        getStartedTitleLabel.setBoldText()
        NSLayoutConstraint.activate([
            getStartedTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStartedTitleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: heightScaler(20)),
            getStartedTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(30)),
            getStartedTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(30))
        ])
    }
    
    private func configGetStartedContentLabel() {
        getStartedContentLabel.setupTitle(text: GettingStartedScreenText.getStartedContent, fontName: FontNames.avenir, size: sizeScaler(32), textColor: .customBlack)
        
        NSLayoutConstraint.activate([
            getStartedContentLabel.topAnchor.constraint(equalTo: getStartedTitleLabel.bottomAnchor, constant: heightScaler(30)),
            getStartedContentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthScaler(50)),
            getStartedContentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -widthScaler(50))
        ])
    }
    
    private func configGetStartedButton() {
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
    private func setupAction() {
        getStartedButton.addTarget(self, action: #selector(getStartedButtonTapped), for: .touchUpInside)
    }
    
    // -MARK: Catch Action
    @objc
    private func getStartedButtonTapped() {
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

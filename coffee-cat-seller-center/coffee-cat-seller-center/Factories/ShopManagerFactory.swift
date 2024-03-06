//
//  ShopManagerFactory.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 06/03/2024.
//

import Foundation
import UIKit
import Lottie


protocol ShopManagerFactory {
    func makeLabel() -> UILabel
    func makeButton() -> UIButton
    func makeVerticalStackView() -> UIStackView
    func makeLottieAnimationView(animationName: String) -> LottieAnimationView
    func makeView() -> UIView
    func makeImageView(imageName: String, size: CGSize) -> UIImageView
}

extension ShopManagerFactory {
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func makeButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func makeVerticalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func makeLottieAnimationView(animationName: String) -> LottieAnimationView {
        let animationView: LottieAnimationView
        animationView = .init(name: animationName)
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }
    
    func makeView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeImageView(imageName: String, size: CGSize) -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        if let image = UIImage(systemName: imageName) {
            imageView.image = image.resized(to: size)
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

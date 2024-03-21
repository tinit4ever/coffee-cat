//
//  BookingManagerFactory.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 05/03/2024.
//

import UIKit
import Lottie

protocol BookingManagerFactory {
    func makeLabel() -> UILabel
    func makeButton() -> UIButton
    func makeLottieAnimationView(animationName: String) -> LottieAnimationView
    func makeView() -> UIView
    func makeImageView(imageName: String, size: CGSize) -> UIImageView
    func makeTableView() -> UITableView
    func makePopupView(frame: CGRect) -> UIView
    func makeBlurView(frame: CGRect, effect: UIBlurEffect) -> UIVisualEffectView
}

extension BookingManagerFactory {
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
    
    func makeTableView() -> UITableView {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }
    
    func makePopupView(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.systemBackground
        view.layer.cornerRadius = 10
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeBlurView(frame: CGRect, effect: UIBlurEffect) -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = frame
        blurView.alpha = 0
        return blurView
    }
}

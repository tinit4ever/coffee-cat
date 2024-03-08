//
//  StaffAccountFactory.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 27/02/2024.
//

import UIKit
import Lottie

protocol StaffAccountFactory {
    func makeLabel() -> UILabel
    func makeButton() -> UIButton
    func makeLottieAnimationView(animationName: String) -> LottieAnimationView
    func makeView() -> UIView
    func makeImageView(imageName: String, size: CGSize) -> UIImageView
    func makeTableView() -> UITableView
}

extension StaffAccountFactory {
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
}

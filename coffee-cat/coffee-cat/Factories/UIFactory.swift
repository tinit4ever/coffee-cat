//
//  UIFactory.swift
//  coffee-cat
//
//  Created by Tin on 03/03/2024.
//

import UIKit
import Lottie

protocol UIFactory {
    func makeLabel() -> UILabel
    func makeButton() -> UIButton
    func makeTextField(placeholder: String) -> UITextField
    func makeRoundedContainer() -> UIView
    func makeView() -> UIView
    func makeVerticalStackView() -> UIStackView
    func makeHorizontalStackView() -> UIStackView
    func makeImageView(imageName: String, size: CGSize) -> UIImageView
    func makeImageView() -> UIImageView
    func makeSquareImageView(imageName: String, size: CGFloat) -> UIImageView
    func makeDatePicker() -> UIDatePicker
    func makeRadioButtonStackView(content: String) -> UIStackView
    func makeLottieAnimationView(animationName: String) -> LottieAnimationView
    func makeSearchBar(placeholder: String) -> UISearchBar
    func makeScrollViewContainer() -> UIScrollView
    func makeTableView() -> UITableView
    func makeCollectionView(space: CGFloat, size: CGSize) -> UICollectionView
    func makePopupView(frame: CGRect) -> UIView
    func makeBlurView(frame: CGRect, effect: UIBlurEffect) -> UIVisualEffectView
}

extension UIFactory {
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
    
    func makeTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func makeRoundedContainer() -> UIView {
        let container = UIView()
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.systemGray3.cgColor
        container.layer.cornerRadius = UIScreen.screenHeightUnit * 15
        container.layer.masksToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }
    
    func makeView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeVerticalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func makeHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func makeInfoHorizontalStackView(firstLabel: UILabel, secondLabel: UILabel, width: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView

        stackView.addArrangedSubview(firstLabel)
        stackView.addArrangedSubview(secondLabel)
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = UIScreen.scalableWidth(10)
//        stackView.widthAnchor.constraint(equalTo: shopInforStackView.widthAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            firstLabel.heightAnchor.constraint(equalToConstant: UIScreen.scalableHeight(28)),
            firstLabel.widthAnchor.constraint(equalToConstant: UIScreen.scalableWidth(280))
        ])
        firstLabel.layer.cornerRadius = UIScreen.scalableSize(10)
        firstLabel.layer.masksToBounds = true
        firstLabel.textAlignment = .center
        firstLabel.backgroundColor = .customPink.withAlphaComponent(0.5)
        
        NSLayoutConstraint.activate([
            secondLabel.heightAnchor.constraint(equalToConstant: UIScreen.scalableHeight(28)),
            secondLabel.widthAnchor.constraint(equalToConstant: UIScreen.scalableWidth(280))
        ])
        secondLabel.layer.cornerRadius = UIScreen.scalableSize(10)
        secondLabel.layer.masksToBounds = true
        secondLabel.textAlignment = .natural
        secondLabel.backgroundColor = .systemGray4.withAlphaComponent(0.5)
        
        return stackView
    }
    
    func makeImageView(imageName: String, size: CGSize) -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        if let image = UIImage(systemName: imageName) {
            imageView.image = image.resized(to: size)
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    func makeImageView() -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    func makeSquareImageView(imageName: String, size: CGFloat) -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        if let image = UIImage(named: imageName) {
            imageView.image = image.resized(to: CGSize(width: size, height: size))
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    func makeDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }
    
    func makeRadioButtonStackView(content: String) -> UIStackView {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        
        let radioButton = makeButton()
        radioButton.ratioButton(false)
        radioButton.isUserInteractionEnabled = false
        
        let label = makeLabel()
        
        stackView.addArrangedSubview(radioButton)
        stackView.addArrangedSubview(label)
        stackView.spacing = UIScreen.scalableSize(10)
        stackView.distribution = .fill
        stackView.alignment = .leading
        label.textAlignment = .left
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: UIScreen.scalableSize(34))
        ])
        label.setupTitle(text: content, fontName: FontNames.avenir, size: UIScreen.scalableSize(28), textColor: .customBlack)
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
    
    func makeSearchBar(placeholder: String) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = placeholder
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }
    
    func makeScrollViewContainer() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
    
    func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    func makeCollectionView(space: CGFloat, size: CGSize) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = size
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.sectionInset = UIEdgeInsets(top: layout.minimumLineSpacing, left: layout.minimumLineSpacing, bottom: layout.minimumLineSpacing, right: layout.minimumLineSpacing)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
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

//
//  MenuFactory.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 03/03/2024.
//

import UIKit

protocol MenuFactory {
    func makeLabel() -> UILabel
    
    func makeButton() -> UIButton
    
    
    func makeButtonWithFrame() -> UIButton
    
    func makePopupView(frame: CGRect) -> UIView
    
    func makeVerticalStackView() -> UIStackView
    
    func makeHorizontalStackView() -> UIStackView
    
    func makeCollectionView(space: CGFloat, size: CGSize) -> UICollectionView
    
    func makeBlurView(frame: CGRect, effect: UIBlurEffect) -> UIVisualEffectView
    
    func makeTextField(placeholder: String) -> UITextField
    
    func makeTextFieldWithFrame(placeholder: String) -> UITextField
}

extension MenuFactory  {
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
    
    func makeButtonWithFrame() -> UIButton {
        let button = UIButton()
        return button
    }
    
    func makeVerticalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }
    
    func makeHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func makeCollectionView(space: CGFloat, size: CGSize) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
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
    
    func makeTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    func makePaddingTextField(with size: CGSize) -> UIView {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        return view
    }
    
    func makeTextFieldWithFrame(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        textField.autocapitalizationType = .none
        return textField
    }
}

//
//  MenuFactory.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 03/03/2024.
//

import UIKit

protocol MenuFactory {
    func makeButton() -> UIButton
    func makeHorizontalStackView() -> UIStackView
    func makeCollectionView(space: CGFloat, size: CGSize) -> UICollectionView
}

extension MenuFactory  {
    func makeButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
}

//
//  CatCollectionViewCell.swift
//  coffee-cat
//
//  Created by Tin on 28/02/2024.
//

import UIKit
import Combine

class CatCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "CatCollectionViewCell"
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var customSelect: Bool = false
    
    // MARK: - Create UIComponents
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "cat")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .customBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .customBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .systemGray3
        self.contentView.layer.cornerRadius = 10
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(imageView)
        self.contentView.layer.cornerRadius = sizeScaler(15)
        self.contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: self.contentView.bounds.height / 3 * 2)
            
        ])
    }
    
    func updateBorder(_ isSelected: Bool) {
        if isSelected {
            self.contentView.layer.borderWidth = widthScaler(7)
        } else {
            self.contentView.layer.borderWidth = widthScaler(0)
        }
    }

    func configure(_ cat: Cat) {
    }
}

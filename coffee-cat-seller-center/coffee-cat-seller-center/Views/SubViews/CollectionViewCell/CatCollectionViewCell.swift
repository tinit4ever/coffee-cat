//
//  CatCollectionViewCell.swift
//  coffee-cat
//
//  Created by Tin on 28/02/2024.
//

import UIKit

class CatCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "CatCollectionViewCell"
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var customSelect: Bool = false
    
    // MARK: - Create UIComponents
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "cat")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var inforStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var nameTitle: UILabel = {
        let label = UILabel()
        
        label.textColor = .customBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .customBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var typeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var typeTitle: UILabel = {
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
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: contentView.bounds.height)
        ])
        
        self.contentView.addSubview(inforStackView)
        NSLayoutConstraint.activate([
            inforStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: heightScaler(10)),
            inforStackView.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: widthScaler(30)),
            inforStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: widthScaler(-15)),
            inforStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: heightScaler(-10))
        ])
        
        inforStackView.addArrangedSubview(nameStackView)
        inforStackView.distribution = .equalCentering
        inforStackView.spacing = heightScaler(15)
        
        nameStackView.addArrangedSubview(nameTitle)
        nameStackView.distribution = .fillEqually
        nameStackView.spacing = heightScaler(5)
        nameTitle.setupTitle(text: "Name", fontName: FontNames.avenir, size: sizeScaler(24), textColor: .customBlack)
        nameTitle.textAlignment = .left
        nameTitle.setBoldText()
    
        nameStackView.addArrangedSubview(nameLabel)
        nameLabel.setupTitle(text: "Beerus", fontName: FontNames.avenir, size: sizeScaler(28), textColor: .customBlack)
        nameLabel.textAlignment = .left
        
        inforStackView.addArrangedSubview(typeStackView)
        typeStackView.addArrangedSubview(typeTitle)
        typeStackView.distribution = .fillEqually
        typeStackView.spacing = heightScaler(5)
        typeTitle.setupTitle(text: "Type", fontName: FontNames.avenir, size: sizeScaler(28), textColor: .customBlack)
        typeTitle.textAlignment = .left
        typeTitle.setBoldText()
        
        typeStackView.addArrangedSubview(typeLabel)
        typeLabel.setupTitle(text: "God", fontName: FontNames.avenir, size: sizeScaler(24), textColor: .customBlack)
        typeLabel.textAlignment = .left
    }
    
    func updateBorder(_ isSelected: Bool) {
        if isSelected {
            self.contentView.layer.borderWidth = widthScaler(7)
        } else {
            self.contentView.layer.borderWidth = widthScaler(0)
        }
    }

    func configure(_ cat: Cat) {
        updateBorder(false)
        self.nameLabel.text = cat.name
        self.typeLabel.text = cat.type
    }
}

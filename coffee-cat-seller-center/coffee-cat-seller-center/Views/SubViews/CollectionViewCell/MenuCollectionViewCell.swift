//
//  MenuCollectionViewCell.swift
//  coffee-cat
//
//  Created by Tin on 28/02/2024.
//

import UIKit
import Combine

class MenuCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "MenuCollectionViewCell"
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    private var cancellables: Set<AnyCancellable> = []
    private var isSelectedSubject = PassthroughSubject<Bool, Never>()
    
    override var isSelected: Bool {
        didSet {
            isSelectedSubject.send(isSelected)
        }
    }
    
    var id: Int?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "food")
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .systemYellow
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        setupUI()
        setupAsync()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(imageView)
        self.contentView.layer.borderColor = UIColor.black.cgColor
        
        imageView.contentMode = .scaleToFill
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: heightScaler(120)),
            imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        self.contentView.addSubview(contentStack)
        contentStack.alignment = .leading
        contentStack.distribution = .fillProportionally
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: widthScaler(20)),
            contentStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: widthScaler(-10)),
            contentStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: heightScaler(-10))
        ])
        
        contentStack.addArrangedSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.setupTitle(text: "Com chien duong chau", fontName: FontNames.avenir, size: sizeScaler(22), textColor: .black)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .left
        titleLabel.widthAnchor.constraint(equalTo: contentStack.widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: heightScaler(50)).isActive = true
        
        contentStack.addArrangedSubview(priceLabel)
        priceLabel.setupTitle(text: "Price: 100.000$", fontName: FontNames.avenir, size: sizeScaler(20), textColor: .black)
        priceLabel.setBoldText()
    }
    
    private func setupAsync() {
        isSelectedSubject
            .sink { [weak self] isSelected in
                self?.updateBorder(isSelected)
            }
            .store(in: &cancellables)
    }
    
    private func updateBorder(_ isSelected: Bool) {
        if isSelected {
            self.contentView.layer.borderWidth = widthScaler(13)
        } else {
            self.contentView.layer.borderWidth = widthScaler(0)
        }
    }
    
    func configure(_ menuItem: MenuItem) {
        self.id = menuItem.id
        self.titleLabel.text = menuItem.name
        self.priceLabel.text = "Price: \(String(describing: menuItem.price ?? 0))$"
    }
}

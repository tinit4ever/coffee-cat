//
//  SeatCollectionViewCell.swift
//  coffee-cat
//
//  Created by Tin on 24/02/2024.
//

import UIKit
import Combine

class SeatCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "SeatCollectionViewCell"
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var customSelect: Bool = false
    
    lazy var status: Bool = false
    
    // MARK: - Create UIComponents
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "coffee-table")
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .customBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var capacityStack: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = widthScaler(10)
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var personImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person")?.withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var capacityLabel: UILabel = {
        let label = UILabel()
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
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: heightScaler(10)),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: heightScaler(10)),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -heightScaler(10)),
            imageView.heightAnchor.constraint(equalToConstant: heightScaler(60)),
            imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        self.contentView.addSubview(titleLabel)
        titleLabel.setupTitle(text: "Unknown", fontName: FontNames.avenir, size: sizeScaler(26), textColor: .customBlack)
        titleLabel.setBoldText()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 1
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: heightScaler(10)),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -heightScaler(10)),
            titleLabel.heightAnchor.constraint(equalToConstant: heightScaler(40))
        ])
        
        capacityLabel.setupTitle(text: "8", fontName: FontNames.avenir, size: sizeScaler(25), textColor: .systemGray6)
        capacityLabel.textAlignment = .left
        contentView.addSubview(capacityStack)
        NSLayoutConstraint.activate([
            capacityStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            capacityStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: widthScaler(15)),
            capacityStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -widthScaler(20)),
            capacityStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -heightScaler(10))
        ])
        capacityStack.addArrangedSubview(personImage)
        capacityStack.addArrangedSubview(capacityLabel)
    }
    
    func updateBorder(_ isSelected: Bool) {
        if status {
            if isSelected {
                self.contentView.layer.borderWidth = widthScaler(7)
            } else {
                self.contentView.layer.borderWidth = widthScaler(0)
            }
        }
    }
    
    func configure(_ seat: Seat) {
        self.updateBorder(false)
        self.titleLabel.text = seat.name
        guard let status = seat.status else {
            return
        }
        self.status = status
        if status {
            self.contentView.backgroundColor = .systemCyan.withAlphaComponent(0.8)
        } else {
            self.contentView.backgroundColor = .systemGray3
        }
        
        if let capacity = seat.capacity {
            self.capacityLabel.text = String(describing: capacity)
        }
    }
}

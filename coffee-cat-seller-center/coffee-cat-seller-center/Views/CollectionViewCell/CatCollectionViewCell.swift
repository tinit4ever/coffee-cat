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
    
    private var cancellables: Set<AnyCancellable> = []
    private var isSelectedSubject = PassthroughSubject<Bool, Never>()
    
    lazy var status: Bool = false
    
    lazy var beforeSelectedState: Bool = false
    
    // MARK: - Create UIComponents
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "cat")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
//    private lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        
//        label.textColor = .customBlack
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        return label
//    }()
    
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
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: heightScaler(10)),
//            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: heightScaler(10)),
//            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -heightScaler(10)),
//            imageView.heightAnchor.constraint(equalToConstant: self.contentView.bounds.height - heightScaler(40)),
//            imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
//        ])
        
//        self.contentView.addSubview(titleLabel)
//        titleLabel.setupTitle(text: "Unknown", fontName: FontNames.avenir, size: sizeScaler(26), textColor: .customBlack)
//        titleLabel.setBoldText()
//        titleLabel.adjustsFontSizeToFitWidth = true
//        titleLabel.numberOfLines = 1
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
//            titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
//            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: heightScaler(10)),
//            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -heightScaler(10)),
//            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -heightScaler(10))
//        ])
    }
    
    func configure(_ cat: Cat) {
//        self.titleLabel.text = cat.description
    }
}

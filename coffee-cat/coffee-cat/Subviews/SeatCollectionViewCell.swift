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
    
    private var cancellables: Set<AnyCancellable> = []
    private var isSelectedSubject = PassthroughSubject<Bool, Never>()
    
    override var isSelected: Bool {
        didSet {
            isSelectedSubject.send(isSelected)
        }
        
        willSet {
            if self.contentView.backgroundColor == .systemBlue {
                self.beforeSelectedState = true
            } else if self.contentView.backgroundColor == .systemGray3 {
                self.beforeSelectedState = false
            }
        }
    }
    
    lazy var beforeSelectedState: Bool = false
    
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
            imageView.heightAnchor.constraint(equalToConstant: self.contentView.bounds.width - heightScaler(50)),
            imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        self.contentView.addSubview(titleLabel)
        titleLabel.setupTitle(text: "Unknown", fontName: FontNames.avenir, size: sizeScaler(26), textColor: .customBlack)
        titleLabel.setBoldText()
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        isSelectedSubject
            .sink { [weak self] isSelected in
                self?.updateBackgroundColor(isSelected)
            }
            .store(in: &cancellables)
    }
    
    private func updateBackgroundColor(_ isSelected: Bool) {
        if isSelected {
            if self.contentView.backgroundColor == .systemBlue {
                self.contentView.backgroundColor = .systemGray3
            } else if self.contentView.backgroundColor == .systemGray3 {
                self.contentView.backgroundColor = .systemBlue
            }
        }
    }
    
    func configure(_ selectedTable: String) {
        self.titleLabel.text = selectedTable
    }
}

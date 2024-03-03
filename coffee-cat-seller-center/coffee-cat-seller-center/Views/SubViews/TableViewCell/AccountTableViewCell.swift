//
//  AccountTableViewCell.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 26/02/2024.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    static let identifier: String = "AccountTableViewCell"
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    lazy var stackContent: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var activeStack: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var activeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var activeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func configUI() {
        contentView.addSubview(stackContent)
        configStackContent()
    }
    
    private func configStackContent() {
//        contentView.backgroundColor = .red
        nameLabel.setupTitle(text: "Customer account", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .customBlack)
        activeLabel.setupTitle(text: "active", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .systemGreen)
        stackContent.spacing = heightScaler(20)
        stackContent.alignment = .leading
        stackContent.distribution = .equalCentering
        NSLayoutConstraint.activate([
            stackContent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: heightScaler(20)),
            stackContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: heightScaler(30)),
            stackContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: heightScaler(-30)),
            stackContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: heightScaler(-20))
        ])
        
        activeStack.spacing = widthScaler(10)
        stackContent.addArrangedSubview(nameLabel)
        stackContent.addArrangedSubview(activeStack)
        activeStack.addArrangedSubview(activeLabel)
        activeStack.addArrangedSubview(activeImageView)
        
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: heightScaler(20)),
            activeStack.heightAnchor.constraint(equalToConstant: heightScaler(20)),
        ])
    }
    
    func config(account: Account) {
        self.nameLabel.text = account.username
        switch account.status {
        case .active:
            activeLabel.textColor = .systemGreen
            activeLabel.text = "active"
            activeImageView.image?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        case .inactive:
            activeLabel.textColor = .systemRed
            activeLabel.text = "inactive"
            let image = UIImage(systemName: "circle.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            activeImageView.image = image
        }
    }
}
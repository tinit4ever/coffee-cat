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
    
    lazy var phoneLabel: UILabel = {
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
    
    lazy var roleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.addSubview(phoneLabel)
        contentView.addSubview(roleLabel)
        configStackContent()
        
    }
    
    private func configStackContent() {
        nameLabel.setupTitle(text: "Customer account", fontName: FontNames.avenir, size: sizeScaler(36), textColor: .customBlack)
        nameLabel.textAlignment = .left
        phoneLabel.setupTitle(text: "Phone", fontName: FontNames.avenir, size: sizeScaler(26), textColor: .systemGray)
      
        activeLabel.setupTitle(text: "active", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .systemGreen)
        roleLabel.setupTitle(text: "STAFF", fontName: FontNames.avenir, size: sizeScaler(30), textColor: .systemMint)
        roleLabel.setBoldText()
      
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
            nameLabel.heightAnchor.constraint(equalToConstant: heightScaler(30)),
            nameLabel.widthAnchor.constraint(equalToConstant: widthScaler(580)),
            activeStack.heightAnchor.constraint(equalToConstant: heightScaler(20)),
            phoneLabel.heightAnchor.constraint(equalToConstant: heightScaler(26)),
            phoneLabel.topAnchor.constraint(equalTo: stackContent.topAnchor),
            phoneLabel.trailingAnchor.constraint(equalTo: stackContent.trailingAnchor),
            roleLabel.heightAnchor.constraint(equalToConstant: heightScaler(26)),
            roleLabel.bottomAnchor.constraint(equalTo: stackContent.bottomAnchor),
            roleLabel.trailingAnchor.constraint(equalTo: stackContent.trailingAnchor)
        ])
    }
    
    func config(account: Account) {
        self.nameLabel.text = account.name
        if let phone = account.phone {
            self.phoneLabel.text = phone
        }
        switch account.status {
        case .active:
            activeLabel.textColor = .systemGreen
            activeLabel.text = "active"
            let image = UIImage(systemName: "circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
            activeImageView.image = image
        case .inactive:
            activeLabel.textColor = .systemRed
            activeLabel.text = "inactive"
            let image = UIImage(systemName: "circle.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            activeImageView.image = image
        }
        
        guard let role = account.role else {
            return
        }
        
        switch role {
        case .customer:
            self.roleLabel.text = "CUSTOMER"
            self.roleLabel.textColor = .customPink
        case .shopOwner:
            self.roleLabel.text = "SHOP OWNER"
            self.roleLabel.textColor = .systemPurple
        case .staff:
            self.roleLabel.text = "STAFF"
            self.roleLabel.textColor = .systemMint
        case .admin:
            break
        }
        
    }
}

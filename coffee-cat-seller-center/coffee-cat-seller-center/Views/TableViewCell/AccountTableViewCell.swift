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
    
    lazy var nameLabel: UILabel = {
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
    
    private func configUI() {
        contentView.addSubview(nameLabel)
        configNameLabel()
    }
    private func configNameLabel() {        
        nameLabel.text = "Customer account"
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthScaler(60))
        ])
    }
}

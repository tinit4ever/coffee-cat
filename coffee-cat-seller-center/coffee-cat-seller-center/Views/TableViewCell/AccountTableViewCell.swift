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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: widthScaler(60), left: widthScaler(40), bottom: 0, right: widthScaler(40)))
    }
    
    private func configUI() {
        contentView.addSubview(nameLabel)
        configNameLabel()
    }
    private func configNameLabel() {
        contentView.layer.cornerRadius = sizeScaler(10)
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .systemGray6
        
        nameLabel.text = "Account"
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthScaler(40))
        ])
    }
}

//
//  ShopTableViewCell.swift
//  coffee-cat
//
//  Created by Tin on 19/02/2024.
//

import UIKit

class ShopTableViewCell: UITableViewCell, UIFactory {
    static let identifier: String = "ShopTableViewCell"
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    lazy var shopImageView: UIImageView = {
        let imageView = UIImageView()
        //        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "NA-Image")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var shopName: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starRatingView: StarRatingView = {
        let starRatingView = StarRatingView()
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        return starRatingView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: widthScaler(40), left: widthScaler(40), bottom: 0, right: widthScaler(40)))
    }
    
    private func configureUI() {
        contentView.addSubview(shopImageView)
        
        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = sizeScaler(10)
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            shopImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shopImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shopImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            shopImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shopImageView.widthAnchor.constraint(equalToConstant: widthScaler(220))
        ])
        
        contentView.addSubview(shopName)
        
        NSLayoutConstraint.activate([
            shopName.topAnchor.constraint(equalTo: shopImageView.topAnchor, constant: heightScaler(10)),
            shopName.leadingAnchor.constraint(equalTo: shopImageView.trailingAnchor, constant: widthScaler(40)),
            shopName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthScaler(20)),
            shopName.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        contentView.addSubview(starRatingView)
        NSLayoutConstraint.activate([
            starRatingView.topAnchor.constraint(equalTo: shopName.bottomAnchor, constant: heightScaler(10)),
            starRatingView.leadingAnchor.constraint(equalTo: shopName.leadingAnchor),
            starRatingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthScaler(20)),
            starRatingView.bottomAnchor.constraint(equalTo: shopImageView.bottomAnchor, constant: -heightScaler(10))
        ])
    }
    
    func configure(shop: Shop) {
        self.starRatingView.rating = shop.rating ?? 0.0
        self.shopImageView.image = UIImage(named: shop.avatar ?? "NA-Image")
        self.setupShopName(shop.name)
    }
    
    private func setupShopName(_ shopName: String) {
        self.shopName.setupTitle(text: shopName, fontName: FontNames.avenir, size: 22, textColor: .customBlack)
        self.shopName.textAlignment = .left
        self.shopName.setBoldText()
    }
}

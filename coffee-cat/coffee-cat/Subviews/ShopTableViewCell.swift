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
    
    private func configureUI() {
        contentView.addSubview(shopImageView)
        shopImageView.layer.cornerRadius = widthScaler(10)
        shopImageView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            shopImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: widthScaler(40)),
            shopImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shopImageView.widthAnchor.constraint(equalToConstant: widthScaler(200)),
            shopImageView.heightAnchor.constraint(equalToConstant: heightScaler(120))
        ])
        
        contentView.addSubview(shopName)
        
        NSLayoutConstraint.activate([
            shopName.topAnchor.constraint(equalTo: shopImageView.topAnchor, constant: heightScaler(20)),
            shopName.leadingAnchor.constraint(equalTo: shopImageView.trailingAnchor, constant: widthScaler(90)),
            shopName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -widthScaler(20))
        ])
        
        contentView.addSubview(starRatingView)
        
        NSLayoutConstraint.activate([
            starRatingView.topAnchor.constraint(equalTo: shopName.bottomAnchor, constant: heightScaler(30)),
            starRatingView.leadingAnchor.constraint(equalTo: shopImageView.trailingAnchor, constant: widthScaler(90)),
            starRatingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -widthScaler(20)),
            starRatingView.bottomAnchor.constraint(equalTo: shopImageView.bottomAnchor, constant: -heightScaler(20))
        ])
    }
    
    func configure(shop: Shop) {
        self.starRatingView.rating = shop.rating ?? 0.0
        self.shopImageView.image = UIImage(named: shop.avatar ?? "NA-Image")
        self.shopName.text = shop.name
    }
}

//
//  BookingHistoryTableViewCell.swift
//  coffee-cat
//
//  Created by Tin on 29/02/2024.
//

import UIKit

class BookingHistoryTableViewCell: UITableViewCell, UIFactory {
    static let identifier: String = "BookingHistoryTableViewCell"
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    lazy var stackBookingDetails = makeVerticalStackView()
    
    lazy var shopNameLabel = makeLabel()
    
    lazy var bookingDateLabel = makeLabel()
    
    lazy var priceLabel = makeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(stackBookingDetails)
        self.contentView.addSubview(bookingDateLabel)
        self.bookingDateLabel.setupTitle(text: "2002-06-26", fontName: FontNames.avenir, size: sizeScaler(26), textColor: .systemGray)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: widthScaler(40), left: 0, bottom: 0, right: 0))
    }
    
    private func configureUI() {
        self.shopNameLabel.text = "Shop 1"
        self.priceLabel.text = "40$"
        self.contentView.layer.cornerRadius = sizeScaler(30)
        self.contentView.layer.borderWidth = sizeScaler(4)
        self.contentView.layer.borderColor = UIColor(ciColor: .gray).cgColor
        self.stackBookingDetails.addArrangedSubview(shopNameLabel)
        stackBookingDetails.distribution = .equalCentering
        shopNameLabel.setupTitle(text: "Shop 1", fontName: FontNames.avenir, size: sizeScaler(40), textColor: .customBlack)
        shopNameLabel.setBoldText()
        shopNameLabel.textAlignment = .left
        
        self.stackBookingDetails.addArrangedSubview(priceLabel)
        
        
        NSLayoutConstraint.activate([
            self.bookingDateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: sizeScaler(30)),
            self.bookingDateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: sizeScaler(-30)),
        ])
        
        NSLayoutConstraint.activate([
            self.stackBookingDetails.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: sizeScaler(30)),
            self.stackBookingDetails.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: sizeScaler(30)),
            self.stackBookingDetails.trailingAnchor.constraint(equalTo: self.bookingDateLabel.leadingAnchor, constant: sizeScaler(-30)),
            self.stackBookingDetails.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: sizeScaler(-30))
        ])
    }
    
    func configure(bookingDetail: BookingDetail) {
        if let shopName = bookingDetail.shopName {
            self.shopNameLabel.text = shopName
        }
        
        self.bookingDateLabel.text = bookingDetail.bookingDate
        self.priceLabel.text = "\(Int(bookingDetail.totalPrice))$"
    }
}

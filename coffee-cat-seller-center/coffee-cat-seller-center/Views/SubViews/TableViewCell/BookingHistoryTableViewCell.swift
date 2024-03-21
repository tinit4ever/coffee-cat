//
//  BookingHistoryTableViewCell.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 05/03/2024.
//

import UIKit

class BookingHistoryTableViewCell: UITableViewCell, ProfileFactory {
    static let identifier: String = "BookingHistoryTableViewCell"
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    lazy var stackBookingDetails = makeVerticalStackView()
    
    lazy var placeNameLabel = makeLabel()
    
    lazy var bookingDateLabel = makeLabel()
    
    lazy var priceLabel = makeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(stackBookingDetails)
        self.contentView.addSubview(bookingDateLabel)
        self.bookingDateLabel.setupTitle(text: "2002-06-26", fontName: FontNames.avenir, size: sizeScaler(26), textColor: .systemGray5)
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
        contentView.backgroundColor = .clear
        self.priceLabel.text = "40$"
        self.contentView.layer.cornerRadius = sizeScaler(30)
        self.contentView.layer.borderWidth = sizeScaler(4)
        self.contentView.layer.borderColor = UIColor(ciColor: .gray).cgColor
        self.stackBookingDetails.addArrangedSubview(placeNameLabel)
        stackBookingDetails.distribution = .equalCentering
        placeNameLabel.setupTitle(text: "Table 1", fontName: FontNames.avenir, size: sizeScaler(32), textColor: .customBlack)
        placeNameLabel.setBoldText()
        placeNameLabel.textAlignment = .left
        
        self.stackBookingDetails.addArrangedSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            self.bookingDateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: sizeScaler(30)),
            self.bookingDateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: sizeScaler(-30)),
        ])
        
        NSLayoutConstraint.activate([
            self.stackBookingDetails.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: sizeScaler(30)),
            self.stackBookingDetails.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: sizeScaler(30)),
            self.stackBookingDetails.widthAnchor.constraint(equalToConstant: widthScaler(550)),
            self.stackBookingDetails.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: sizeScaler(-30))
        ])
    }
    
    func configure(bookingDetail: BookingDetail) {
        if let seatName = bookingDetail.seatName,
           let areaName = bookingDetail.areaName {
            self.placeNameLabel.text = "\(seatName) in \(areaName)"
        }
        self.bookingDateLabel.text = bookingDetail.bookingDate
        self.priceLabel.text = "\(Int(bookingDetail.totalPrice))$"
    }
}

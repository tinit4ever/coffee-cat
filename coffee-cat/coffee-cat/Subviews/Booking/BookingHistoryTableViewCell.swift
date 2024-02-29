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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        self.contentView.layer.cornerRadius = sizeScaler(30)
        self.contentView.layer.borderWidth = sizeScaler(4)
        self.contentView.layer.borderColor = UIColor(ciColor: .gray).cgColor
    }
    
    func configure() {
    }
}

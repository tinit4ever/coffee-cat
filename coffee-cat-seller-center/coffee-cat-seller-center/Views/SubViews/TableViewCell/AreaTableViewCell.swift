//
//  AreaTableViewCell.swift
//  coffee-cat
//
//  Created by Tin on 27/02/2024.
//

import UIKit
import Combine

class AreaTableViewCell: UITableViewCell {
    static let identifier: String = "AreaTableViewCell"
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var seatList: [Seat] = []
    var didSelectedSeat: ((SeatId, Bool) -> Void)?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.scalableWidth(230), height: UIScreen.scalableHeight(140))
        layout.minimumLineSpacing = UIScreen.scalableHeight(20)
        layout.minimumInteritemSpacing = UIScreen.scalableHeight(20)
        layout.sectionInset = UIEdgeInsets(top: layout.minimumLineSpacing, left: layout.minimumLineSpacing, bottom: layout.minimumLineSpacing * 2, right: layout.minimumLineSpacing * 2.5)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        contentView.layer.cornerRadius = sizeScaler(20)
        contentView.layer.masksToBounds = true
        collectionView.register(SeatCollectionViewCell.self, forCellWithReuseIdentifier: SeatCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
        collectionView.backgroundColor = .systemBrown
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: widthScaler(30), left: widthScaler(30), bottom: 0, right: widthScaler(30)))
    }
    
    func configure(seatList: [Seat]) {
        self.seatList = seatList
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension AreaTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.seatList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeatCollectionViewCell.identifier, for: indexPath) as? SeatCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let seat = seatList[indexPath.row]
        cell.configure(seat)
        
        return cell
    }
}

extension AreaTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SeatCollectionViewCell else {
            return
        }
        let beforeSelect = cell.customSelect
        
        guard let seatId = self.seatList[indexPath.row].id else {
            return
        }
        
        if beforeSelect {
            cell.customSelect = false
            cell.updateBorder(false)
            self.didSelectedSeat?(SeatId(id: seatId), false)
        } else {
            cell.customSelect = true
            cell.updateBorder(true)
            self.didSelectedSeat?(SeatId(id: seatId), true)
        }
    }
}

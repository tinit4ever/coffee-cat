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
    var sendSelectedTableIndex: ((IndexPath, IndexPath) -> Void)?
    var areaIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    private var cancellables: Set<AnyCancellable> = []
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.scalableWidth(180), height: UIScreen.scalableHeight(80))
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
    
    func configure(seatList: [Seat], indexPath: IndexPath) {
        self.seatList = seatList
        self.areaIndexPath = indexPath
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
        if let seatStatus = self.seatList[indexPath.row].status {
            if seatStatus {
                self.sendSelectedTableIndex?(self.areaIndexPath, indexPath)
            }
        }
    }
}

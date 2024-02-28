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
    var didSelectSeat: ((Seat, Bool) -> Void)?
    var isIncrease: Bool = false {
        didSet {
            isAvailableToSubmit.send(isIncrease)
        }
    }
    var selectedSeat: Seat?
    
    private var cancellables: Set<AnyCancellable> = []
    private var isAvailableToSubmit = PassthroughSubject<Bool, Never>()
    
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
        
        isAvailableToSubmit
            .sink { [weak self] isIncrease in
                if isIncrease {
                    self?.didSelectSeat?((self?.selectedSeat)!, isIncrease)
                    print(isIncrease)
                } else {
                    print(isIncrease)
                    self?.didSelectSeat?((self?.selectedSeat)!, isIncrease)
                }
            }
            .store(in: &cancellables)
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
        
        let cell = collectionView.cellForItem(at: indexPath) as? SeatCollectionViewCell
        guard let isSelected = cell?.beforeSelectedState else {
            return
        }
        let selectedSeat = self.seatList[indexPath.row]
        if selectedSeat.status ?? false {
            if !isSelected {
                self.selectedSeat = selectedSeat
                self.isIncrease = true
            } else {
                self.isIncrease = false
            }
        }
    }
}

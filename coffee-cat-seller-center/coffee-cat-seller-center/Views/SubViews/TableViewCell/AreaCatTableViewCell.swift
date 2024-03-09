//
//  AreaCatTableViewCell.swift
//  coffee-cat
//
//  Created by Tin on 28/02/2024.
//

import UIKit
import Combine

class AreaCatTableViewCell: UITableViewCell {
    static let identifier: String = "AreaCatTableViewCell"
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var catList: [Cat] = []
    var didSelectedCat: ((CatId, Bool) -> Void)?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.scalableWidth(780), height: UIScreen.scalableHeight(160))
        layout.minimumLineSpacing = widthScaler(80)
        let space = widthScaler(80)
        layout.sectionInset = UIEdgeInsets(top: space, left: 0, bottom: space, right: space)
        
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
        collectionView.register(CatCollectionViewCell.self, forCellWithReuseIdentifier: CatCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
        collectionView.backgroundColor = .systemBrown
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: widthScaler(30), left: widthScaler(30), bottom: widthScaler(30), right: widthScaler(30)))
    }
    
    func configure(catList: [Cat]) {
        self.catList = catList
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension AreaCatTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.catList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatCollectionViewCell.identifier, for: indexPath) as? CatCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let cat = catList[indexPath.row]
        cell.configure(cat)
        
        return cell
    }
}

extension AreaCatTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CatCollectionViewCell else {
            return
        }
        let beforeSelect = cell.customSelect
        
        let catId = self.catList[indexPath.row].id
        
        if beforeSelect {
            cell.customSelect = false
            cell.updateBorder(false)
            self.didSelectedCat?(CatId(catId: catId), false)
        } else {
            cell.customSelect = true
            cell.updateBorder(true)
            self.didSelectedCat?(CatId(catId: catId), true)
        }
    }
}

//
//  SelectTableViewController.swift
//  coffee-cat
//
//  Created by Tin on 25/02/2024.
//

import UIKit
import SwiftUI

class SelectTableViewController: UIViewController, UIFactory {
    let heightScaler = UIScreen.scalableHeight
    let widthScaler = UIScreen.scalableWidth
    let sizeScaler = UIScreen.scalableSize
    
    var didSendData: (([String]) -> Void)?
    //    var seatList: [String] = []
    var seatList: [String] = []
    
    var selectedTable: [String] = []
    // MARK: - Create UIComponents
    lazy var seatListCollectionView = makeCollectionView(space: sizeScaler(20), size: CGSize(width: heightScaler(110), height: heightScaler(110)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .customPink
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = .customPink
        
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        
        view.backgroundColor = .systemGray6
        
        view.addSubview(seatListCollectionView)
        configSeatListCollectionView()
    }
    
    private func configSeatListCollectionView() {
        seatListCollectionView.delegate = self
        seatListCollectionView.dataSource = self
        seatListCollectionView.register(SeatCollectionViewCell.self, forCellWithReuseIdentifier: SeatCollectionViewCell.identifier)
        
        NSLayoutConstraint.activate([
            seatListCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            seatListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            seatListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            seatListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        didSendData?(self.selectedTable)
        self.dismiss(animated: true)
    }
}
extension SelectTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seatList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeatCollectionViewCell.identifier, for: indexPath) as? SeatCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(self.seatList[indexPath.row])
        
        return cell
    }
}
extension SelectTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? SeatCollectionViewCell
        if let isSelected = cell?.beforeSelectedState {
            if isSelected {
                if let index = self.selectedTable.firstIndex(of: self.seatList[indexPath.row]) {
                    self.selectedTable.remove(at: index)
                }
            } else {
                self.selectedTable.append(self.seatList[indexPath.row])
            }
        }
    }
}
// -MARK: Preview
struct SelectTableViewControllerPreview: PreviewProvider {
    static var previews: some View {
        VCPreview {
            let selectTableViewController = SelectTableViewController()
            return selectTableViewController
        }
    }
}


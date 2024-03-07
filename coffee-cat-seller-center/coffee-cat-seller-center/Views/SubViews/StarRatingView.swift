//
//  StarRatingView.swift
//  coffee-cat-seller-center
//
//  Created by Tin on 06/03/2024.
//

import UIKit

class StarRatingView: UIView {
    private var starImageViews: [UIImageView] = []

    var rating: Double = 0 {
        didSet {
            updateRating()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStars()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStars()
    }

    private func setupStars() {
        for _ in 1...5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.image = UIImage(systemName: "star.fill")
            starImageView.tintColor = .orange
            starImageViews.append(starImageView)
            addSubview(starImageView)
        }

        updateRating()
    }

    private func updateRating() {
        for (index, starImageView) in starImageViews.enumerated() {
            starImageView.image = index < Int(rating) ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let starSize = bounds.height
        let spacing: CGFloat = 4.0

        for (index, starImageView) in starImageViews.enumerated() {
            let xPosition = CGFloat(index) * (starSize + spacing)
            starImageView.frame = CGRect(x: xPosition, y: 0, width: starSize, height: starSize)
        }
    }
}

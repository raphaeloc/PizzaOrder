//
//  OrderCollectionViewCell.swift
//  PizzaOrder
//
//  Created by Raphael de Oliveira Chagas on 20/05/21.
//

import UIKit
import SkeletonView

class OrderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingStackView: RatingStackView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.allCorners], radius: 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.hideSkeleton()
        nameLabel.hideSkeleton()
        priceTitleLabel.hideSkeleton()
        priceLabel.hideSkeleton()
        ratingStackView.hideSkeleton()
        
        imageView.stopSkeletonAnimation()
        nameLabel.stopSkeletonAnimation()
        priceTitleLabel.stopSkeletonAnimation()
        priceLabel.stopSkeletonAnimation()
        ratingStackView.stopSkeletonAnimation()
    }

    func setup(withItem item: Item) {
        imageView.downloaded(from: item.imageUrl)
        nameLabel.text = item.name
        priceLabel.text = String(format: "R$ %.02f", item.priceP).replacingOccurrences(of: ".", with: ",")
        ratingStackView.rating = item.rating
    }
    
    func setupForSkeleton() {
        imageView.showAnimatedSkeleton(usingColor: UIColor(hex: 0x1a1a1a))
        nameLabel.showAnimatedSkeleton(usingColor: UIColor(hex: 0x1a1a1a))
        priceTitleLabel.showAnimatedSkeleton(usingColor: UIColor(hex: 0x1a1a1a))
        priceLabel.showAnimatedSkeleton(usingColor: UIColor(hex: 0x1a1a1a))
        ratingStackView.showAnimatedSkeleton(usingColor: UIColor(hex: 0x1a1a1a))
    }
}

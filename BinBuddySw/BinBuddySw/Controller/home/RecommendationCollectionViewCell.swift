//
//  RecommendationCollectionViewCell.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 11/01/25.
//

import UIKit

class RecommendationCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var appImageView: UIImageView!
    
    @IBOutlet weak var appNameLabel: UILabel!
    
    func configure(with app: AppInfo) {
            appNameLabel.text = app.title ?? "Sin título"
            if let logos = app.logos,
               let logo = logos.first(where: { $0.size == "100x100" }),
               let url = URL(string: logo.link ?? "") {
                appImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            } else {
                appImageView.image = UIImage(named: "placeholder")
            }
            appImageView.layer.cornerRadius = appImageView.frame.width / 2
            appImageView.clipsToBounds = true
        }
}

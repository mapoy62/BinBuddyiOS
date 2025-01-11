//
//  EventBannerCollectionViewCell.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 10/01/25.
//

import UIKit
import SDWebImage

class EventBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    func configure(with imageUrl: String) {
            
            // Usando SDWebImage para cargar la imagen
            if let url = URL(string: imageUrl) {
                eventImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            }
        //Reajustar el tamño de la imagen al contenedor
        eventImageView.contentMode = .scaleAspectFit
        bannerImageView.layer.cornerRadius = 10
        eventImageView.clipsToBounds = true
    }
}

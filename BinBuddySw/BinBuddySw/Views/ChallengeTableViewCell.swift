//
//  ChallengeCell.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//

import UIKit
import SDWebImage

class ChallengeTableViewCell: UITableViewCell {

    @IBOutlet weak var challengeIV: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    func configure(with challenge: Challenge) {
            titleLabel.text = challenge.name
            descLabel.text = challenge.description

            if let url = URL(string: challenge.imgUrl) {
                challengeIV.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            }
            
        // Configurar imagen como círculo
        challengeIV.layer.cornerRadius = challengeIV.frame.height / 2
        challengeIV.clipsToBounds = true
        }

}

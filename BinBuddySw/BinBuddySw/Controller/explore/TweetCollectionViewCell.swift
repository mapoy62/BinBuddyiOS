//
//  TweetCollectionViewCell.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 09/01/25.
//

import UIKit

class TweetCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    
    func configure(with tweet: Tweet, image: UIImage?) {
            tweetTextLabel.text = tweet.text
            tweetImageView.image = image

            // Ajustar diseño si no hay imagen
            tweetImageView.isHidden = image == nil
        }
}

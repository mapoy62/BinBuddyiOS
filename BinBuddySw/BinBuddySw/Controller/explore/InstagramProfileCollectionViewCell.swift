//
//  InstagramProfileCollectionViewCell.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 10/01/25.
//

import UIKit

class InstagramProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabe: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    func configure(with profile: InstagramProfile) {
        usernameLabe.text = profile.username
        categoryLabel.text = profile.category

            // Cargar imagen desde URL
            if let url = URL(string: profile.imageUrl) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.profileImageView.image = image
                        }
                    }
                }.resume()
            }
        }
}

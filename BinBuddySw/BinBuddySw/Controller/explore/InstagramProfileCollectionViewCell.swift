//
//  InstagramProfileCollectionViewCell.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 22/12/24.
//

import UIKit
import SDWebImage

class InstagramProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Configurar la apariencia inicial
        setupUI()
    }
    
    func setupUI() {
            // Asegúrate de que profileImageView no es nil antes de modificar sus propiedades
            profileImageView?.layer.cornerRadius = profileImageView.frame.width / 2
            profileImageView?.clipsToBounds = true
        }
        
        func configure(with profile: InstagramProfile) {
            usernameLabel.text = "@\(profile.username)"
            bioLabel.text = profile.bio
            if let url = URL(string: profile.profileImageURL) {
                        profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
                    } else {
                        profileImageView.image = UIImage(named: "placeholder")
                    }
        }
    
}

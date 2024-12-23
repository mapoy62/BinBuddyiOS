//
//  ChallengeCell.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//

import UIKit
import SDWebImage

class ChallengeCell: UITableViewCell {

    @IBOutlet weak var challengeIV: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        challengeIV.layer.cornerRadius = 8
        challengeIV.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with challenge: ChallengeEntity) {
        
        titleLabel.text = challenge.name
        descLabel.text = challenge.desc
        progressView.progress = min(Float(challenge.points) / 100.0, 1.0)
        
        if let urlString = challenge.imgUrl, let url = URL(string: urlString) {
                   // Cargar la imagen con SDWebImage y usar un placeholder
            challengeIV.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: .highPriority, completed: { (image, error, cacheType, url) in
                       if let error = error {
                           print("Error al cargar la imagen: \(error.localizedDescription)")
                           self.challengeIV.image = UIImage(named: "placeholder")
                       } else {
                           print("Imagen cargada exitosamente desde: \(url?.absoluteString ?? "URL desconocida")")
                       }
                   })
               } else {
                   // Usar la imagen de placeholder si la URL es inválida
                   challengeIV.image = UIImage(named: "placeholder")
                   print("URL de imagen inválida para desafío: \(String(describing: challenge.name))")
               }
    }

}

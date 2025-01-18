//
//  RewardCollectionViewCell.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//

import UIKit
import SDWebImage

class RewardCollectionViewCell: UICollectionViewCell {
    private let nameLabel = UILabel()
    private let imageView = UIImageView()
    private let infoButton = UIButton(type: .infoLight)
    
    // Callback para manejar el toque del botón
    var onInfoTapped: (() -> Void)?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Configure ImageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        contentView.addSubview(imageView)

        // Configure NameLabel
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)

        // Configure InfoButton
        contentView.addSubview(infoButton)

        // Constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        infoButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            infoButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            infoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    func configure(with reward: Reward) {
        nameLabel.text = reward.name
        if let url = URL(string: reward.imageUrl ?? "") {
            imageView.sd_setImage(with: url)
        }
        
        // Configurar el callback del botón de info
        onInfoTapped = { [weak self] in
            self?.showDescriptionTooltip(description: reward.description)
        }
    }
    
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        onInfoTapped?()
    }
    
    private func showDescriptionTooltip(description: String) {
            guard let parentView = self.superview else { return }
            
            // Crear un Tooltip como UILabel
            let tooltipLabel = UILabel()
            tooltipLabel.text = description
            tooltipLabel.numberOfLines = 0
            tooltipLabel.font = UIFont.systemFont(ofSize: 14)
            tooltipLabel.textColor = .white
            tooltipLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            tooltipLabel.layer.cornerRadius = 8
            tooltipLabel.layer.masksToBounds = true
            tooltipLabel.textAlignment = .center
            tooltipLabel.alpha = 0
            
            // Calcular posición y tamaño
            tooltipLabel.frame = CGRect(x: frame.origin.x, y: frame.origin.y - 60, width: 200, height: 60)
            tooltipLabel.center.x = parentView.convert(center, to: parentView).x
            parentView.addSubview(tooltipLabel)

            // Animar la aparición del Tooltip
            UIView.animate(withDuration: 0.3) {
                tooltipLabel.alpha = 1
            }

            // Desaparecer después de 3 segundos
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.3, animations: {
                    tooltipLabel.alpha = 0
                }, completion: { _ in
                    tooltipLabel.removeFromSuperview()
                })
            }
        }
}


//
//  InstagramCategoryTableViewCell.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 22/12/24.
//

import UIKit

class InstagramCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var profiles: [InstagramProfile] = []
        
        override func awakeFromNib() {
            super.awakeFromNib()
            
            // Configurar la colección
            collectionView.delegate = self
            collectionView.dataSource = self
            
            // Registrar la celda de perfil
            
            //let nib = UINib(nibName: "InstagramProfileCollectionViewCell", bundle: nil)
            //collectionView.register(nib, forCellWithReuseIdentifier: "InstagramProfileCell")
            
            // Configurar el layout de la colección
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
                layout.minimumLineSpacing = 16
                layout.itemSize = CGSize(width: 100, height: 140)
                layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            }
        }
        
        func configure(with category: InstagramCategory) {
            categoryTitleLabel.text = category.title
            self.profiles = category.profiles
            collectionView.reloadData()
        }
    }

    extension InstagramCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
        
        // Número de items
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return profiles.count
        }
        
        // Configurar cada celda de perfil
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstagramProfileCell", for: indexPath) as? InstagramProfileCollectionViewCell else {
                fatalError("No se pudo dequeuar InstagramProfileCollectionViewCell")
            }
            
            let profile = profiles[indexPath.item]
            cell.configure(with: profile)
            
            return cell
        }
        
        // Manejar la selección de un perfil
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let profile = profiles[indexPath.item]
            // Notificar al controlador de vista para manejar la navegación
            NotificationCenter.default.post(name: .didSelectInstagramProfile, object: profile)
        }
    }

    // Definir una notificación para la selección de perfil
    extension Notification.Name {
        static let didSelectInstagramProfile = Notification.Name("didSelectInstagramProfile")
    }

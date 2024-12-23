//
//  ExploreViewController.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//

import UIKit

class ExploreViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories = InstagramData.categories
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNotifications()
        loadInstagramData()
    }
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Registrar la celda de categoría
        //let nib = UINib(nibName: "InstagramCategoryTableViewCell", bundle: nil)
        //tableView.register(nib, forCellReuseIdentifier: "InstagramCategoryCell")
        
        // Configurar el tamaño de la fila
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfileSelection(_:)), name: .didSelectInstagramProfile, object: nil)
    }
    
    @objc func handleProfileSelection(_ notification: Notification) {
            if let profile = notification.object as? InstagramProfile {
                openInstagramProfile(username: profile.username)
            }
        }
    
    func loadInstagramData() {
            // Cargar datos estáticos
            self.categories = InstagramData.categories
            self.tableView.reloadData()
            
            // Opcional: Cargar datos desde una API externa
            // fetchInstagramCategoriesFromAPI()
        }
        
    func openInstagramProfile(username: String) {
        let appURLString = "instagram://user?username=\(username)"
                guard let appURL = URL(string: appURLString) else {
                    print("URL inválida para Instagram.")
                    return
                }
                
                let webURLString = "https://instagram.com/\(username)"
                guard let webURL = URL(string: webURLString) else {
                    print("URL inválida para Instagram en Safari.")
                    return
                }
                
                if UIApplication.shared.canOpenURL(appURL) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                }
            }
            
            // ... [Otros métodos para tweets, mapa y scan]
    }

    extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
        
        // Número de secciones: igual al número de categorías
           func numberOfSections(in tableView: UITableView) -> Int {
               return categories.count
           }
           
           // Título de cada sección (opcional si ya tienes un UILabel en la celda)
           func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
               return categories[section].title
           }
           
           // Número de filas por sección: 1 (cada fila tiene una UICollectionView)
           func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return 1
           }
           
           // Configurar cada celda de categoría
           func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

               guard let cell = tableView.dequeueReusableCell(withIdentifier: "InstagramCategoryCell", for: indexPath) as? InstagramCategoryTableViewCell else {
                   fatalError("No se pudo dequeuar InstagramCategoryTableViewCell")
               }
               
               let category = categories[indexPath.section]
               cell.configure(with: category)
               
               return cell
           }
    }

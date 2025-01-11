//
//  HomeViewController.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate {
        
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    @IBOutlet weak var tipsTableView: UITableView!
    
    
    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    
    
    @IBAction func addTipButtonTapped(_ sender: UIButton) {
        // Crear el UIAlertController
        let alertController = UIAlertController(title: "My recommendation for you",message: "Task: ",
                                                    preferredStyle: .alert)
            
            // Agregar un campo de texto
            alertController.addTextField { textField in
                textField.placeholder = "Write your recommendation here..."
            }
            
            // Agregar un botón "Guardar"
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                // Obtener el texto ingresado
                if let tip = alertController.textFields?.first?.text, !tip.isEmpty {
                    // Llamar a una función para agregar el tip
                    self.addNewTip(tip)
                }
            }
            
            // Agregar un botón "Cancelar"
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            // Agregar las acciones al UIAlertController
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            // Presentar el UIAlertController
            present(alertController, animated: true, completion: nil)
    }

    func addNewTip(_ tip: String) {
        DatabaseManager.shared.insertTip(tip)
        tips = DatabaseManager.shared.fetchTips() // Recargar los datos
        tipsTableView.reloadData()
    }


    
    //Arreglo de imágenmes para el banner de eventos
    private var imageLinks: [String] = []
    private let eventService = EventService()
    
    private var tips: [String] = [
        "Separa tus residuos en orgánicos e inorgánicos.",
        "Reutiliza envases de vidrio como recipientes.",
        "Evita comprar productos con envases de plástico innecesarios."
    ]
    
    private var recommendedApps: [AppInfo] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configuración del Collection View
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        
        tipsTableView.dataSource = self
        tipsTableView.delegate = self

        // Eliminar líneas vacías
        tipsTableView.tableFooterView = UIView()

        // Obtener enlaces de las imágenes
        fetchImageLinks()
        
        //Obtener las recomendaciones - cargados desde SQLite
        tips = DatabaseManager.shared.fetchTips() // Cargar los datos de SQLite
        tipsTableView.reloadData()
        
        //Obtener app con búsqueda environment
        recommendationsCollectionView.dataSource = self
                recommendationsCollectionView.delegate = self

                // Llamar a la función para obtener aplicaciones
                let appStoreService = AppStoreService()
                appStoreService.fetchApps(keyword: "environment") { [weak self] apps in
                    guard let self = self, let apps = apps else { return }

                    DispatchQueue.main.async {
                        // Asignar los resultados al array y recargar la colección
                        self.recommendedApps = apps
                        self.recommendationsCollectionView.reloadData()
                    }
                }
    }

    private func fetchImageLinks() {
        eventService.fetchImageLinks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let links):
                    self?.imageLinks = links
                    self?.bannerCollectionView.reloadData()
                case .failure(let error):
                    print("Error al obtener los enlaces de imágenes: \(error.localizedDescription)")
                }
            }
        }
    }

}

//Config de scroll horizontal
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Ajustar el tamaño de la celda al ancho del Collection View
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TipCell", for: indexPath)
        cell.textLabel?.text = tips[indexPath.row]
        cell.textLabel?.numberOfLines = 0 // Permite múltiples líneas para textos largos
        return cell
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1: // Banner de Eventos
            return imageLinks.count
        case 2: // Recomendaciones de Aplicaciones
            return recommendedApps.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1: // Banner de Eventos
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventBannerCell", for: indexPath) as! EventBannerCollectionViewCell
            let imageUrl = imageLinks[indexPath.item]
            cell.configure(with: imageUrl)
            return cell
            
        case 2: // Recomendaciones de Aplicaciones
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendationCell", for: indexPath) as! RecommendationCollectionViewCell
            let app = recommendedApps[indexPath.item]
            cell.configure(with: app)
            return cell
            
        default:
            fatalError("No se reconoce el UICollectionView")
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 1: // Banner de Eventos
            print("Evento seleccionado en el banner: \(indexPath.item)")
            
        case 2: // Recomendaciones de Aplicaciones
            let app = recommendedApps[indexPath.item]
            if let url = URL(string: app.link ?? "None") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        default:
            break
        }
    }
}




//
//  ChallengesViewController.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//

import UIKit
import CoreData

class ChallengesViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
    
    var challenges: [ChallengeEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        loadChallenges()
    }
    

    func setupTableView() {
        tableView.delegate = self
            tableView.dataSource = self

            // Opcional: Configurar el estilo de la tabla
            tableView.separatorStyle = .none
        }
    
    func loadChallenges() {
        // Mostrar un indicador de actividad
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        // Llenar la base de datos desde el backend
        DataManager.shared.fillDatabase { [weak self] in
            DispatchQueue.main.async {
                // Obtener los desafíos de Core Data
                self?.challenges = DataManager.shared.getAllChallenges()
                self?.tableView.reloadData()
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                
                if self?.challenges.isEmpty ?? true {
                    self?.showNoChallengesMessage()
                }
            }
        }
    }
    
    func showNoChallengesMessage() {
            let messageLabel = UILabel()
            messageLabel.text = "No hay desafíos disponibles."
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            messageLabel.textColor = .gray
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(messageLabel)

            NSLayoutConstraint.activate([
                messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ChallengesViewController: UITableViewDelegate, UITableViewDataSource {

    // Número de filas en la sección
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }

    // Configurar la celda
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCell", for: indexPath) as? ChallengeCell else {
            return UITableViewCell()
        }

        let challenge = challenges[indexPath.row]
        cell.configure(with: challenge)
        return cell
    }

    // Manejar la selección de una fila
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let challenge = challenges[indexPath.row]
        showChallengeDetail(challenge: challenge)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Tamaño de la fila (opcional)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Ajusta según el diseño de la celda
    }

    
    // Función para mostrar el detalle del desafío
    func showChallengeDetail(challenge: ChallengeEntity) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "ChallengeDetailViewController") as? ChallengeDetailViewController {
            detailVC.challenge = challenge
            detailVC.modalPresentationStyle = .overFullScreen
            detailVC.modalTransitionStyle = .crossDissolve
            present(detailVC, animated: true, completion: nil)
        }
    }
     
}

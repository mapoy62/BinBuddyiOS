//
//  ChallengesViewController.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//

import UIKit
import CoreData
import Foundation

class ChallengesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    var challenges: [Challenge] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "Challenges"

            // Configuración del TableView
            tableView.dataSource = self
            tableView.delegate = self

            // Estilo de la tabla
            tableView.separatorStyle = .none
            tableView.estimatedRowHeight = 100
            tableView.rowHeight = UITableView.automaticDimension

            // Cargar desafíos
            loadChallenges()
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return challenges.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCell", for: indexPath) as? ChallengeTableViewCell else {
                fatalError("No se pudo cargar la celda personalizada")
            }
            let challenge = challenges[indexPath.row]
            cell.configure(with: challenge)
            return cell
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedChallenge = challenges[indexPath.row]

                if let detailVC = storyboard?.instantiateViewController(withIdentifier: "ChallengeDetailViewController") as? ChallengeDetailViewController {
                    detailVC.challengeID = selectedChallenge.id
                    navigationController?.pushViewController(detailVC, animated: true)
                }
        }



        private func loadChallenges() {
            if let savedChallenges = ChallengeDataManager.shared.loadChallenges() {
                // Cargar desde almacenamiento local
                self.challenges = savedChallenges
                self.tableView.reloadData()
                print("Cargando desafíos desde almacenamiento local")
            } else {
                // Cargar desde el backend
                ChallengeDataManager.shared.fetchChallenges { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let fetchedChallenges):
                            self?.challenges = fetchedChallenges
                            self?.tableView.reloadData()
                            print("Desafíos cargados desde el backend")
                        case .failure(let error):
                            self?.showError(message: error.localizedDescription)
                        }
                    }
                }
            }
        }

        private func showError(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
}


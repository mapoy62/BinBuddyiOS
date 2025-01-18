//
//  RewardsViewController.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//

import UIKit

class RewardsViewController: UIViewController{
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private var rewards: [Reward] = []
        private var filteredRewards: [Reward] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Rewards"
            setupCollectionView()
            fetchRewards()
        }

        private func setupCollectionView() {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(RewardCollectionViewCell.self, forCellWithReuseIdentifier: "RewardCell")
        }

        @IBAction func filterRewards(_ sender: UISegmentedControl) {
            let category = sender.selectedSegmentIndex
            switch category {
            case 0: filteredRewards = rewards
            case 1: filteredRewards = rewards.filter { $0.category == "services" }
            case 2: filteredRewards = rewards.filter { $0.category == "entertainment" }
            case 3: filteredRewards = rewards.filter { $0.category == "environment" }
            default: break
            }
            collectionView.reloadData()
        }

        private func fetchRewards() {
            RewardService.fetchRewards { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let rewards):
                        self?.rewards = rewards
                        self?.filteredRewards = rewards
                        self?.collectionView.reloadData()
                    case .failure(let error):
                        print("Error fetching rewards: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

extension RewardsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return filteredRewards.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RewardCell", for: indexPath) as! RewardCollectionViewCell
            let reward = filteredRewards[indexPath.item]
            cell.configure(with: reward)
            
            // Manejo del botón de info
            cell.onInfoTapped = { [weak self] in
                self?.showTooltip(for: reward)
            }
            
            return cell
        }

    private func showTooltip(for reward: Reward) {
        let tooltipMessage = reward.description
        let alert = UIAlertController(title: "Información", message: tooltipMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Ajusta el tamaño para dos columnas
        let padding: CGFloat = 16 // Espaciado entre celdas
        let totalPadding = padding * 3 // 2 espaciados + márgenes
        let individualWidth = (collectionView.frame.width - totalPadding) / 2
        
        return CGSize(width: individualWidth, height: individualWidth * 1.5) // Rectángulo vertical
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16 // Espaciado vertical entre filas
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16 // Espaciado horizontal entre columnas
    }
}

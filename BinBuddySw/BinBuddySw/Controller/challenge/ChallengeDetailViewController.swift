//
//  ChallengeDetailViewController.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//

import UIKit
import SDWebImage
import Social
import CoreData

class ChallengeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var dayStackView: UIStackView!
    
    var challengeID: Int?
    private var dayCheckboxes: [DayCheckboxView] = []
    private var totalDays: Int = 7 // Por defecto, el reto es de 7 días
    private var challengeDetail: ChallengeDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchChallengeDetails()
    }
    
    
    //SetUp UI and dorners on images
    private func setupUI() {
        // Configuración de la barra de progreso
        progressBar.progress = 0.0
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true

        // Configuración de la imagen circular
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true

        // Configuración de los StackViews
        dayStackView.axis = .horizontal
        dayStackView.alignment = .center
        dayStackView.spacing = 16
        dayStackView.distribution = .fillEqually

        /*
        rewardsStackView.axis = .horizontal
        rewardsStackView.alignment = .center
        rewardsStackView.spacing = 16
        rewardsStackView.distribution = .fillEqually
        */
    }
    
    private func fetchChallengeDetails() {
        guard let challengeID = challengeID else {
            print("No se proporcionó un ID de desafío.")
            return
        }

        ChallengeService.fetchChallengeDetails(by: challengeID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self?.challengeDetail = detail
                    self?.updateUI(with: detail)
                    print("")
                case .failure(let error):
                    self?.showError(message: "Error: \(error.localizedDescription)")
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func updateUI(with challenge: ChallengeDetail) {
            titleLabel.text = challenge.name
            descLabel.text = challenge.description

            // Cargar imagen con SDWebImage
        if let url = URL(string: challenge.imgUrl ?? "") {
                imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            }

            // Configurar checkboxes de días
            setupDayCheckboxes(for: totalDays)

            // Configurar recompensas
            //setupRewards(challenge.rewards)

            // Actualizar barra de progreso
        updateProgress(progress: challenge.progress ?? 0)
        }
    
    private func setupDayCheckboxes(for totalDays: Int) {
            dayStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

            for day in 1...totalDays {
                let dayView = DayCheckboxView(day: day)
                dayView.onButtonTapped = { [weak self] in
                    self?.updateProgressDynamically()
                }
                dayCheckboxes.append(dayView)
                dayStackView.addArrangedSubview(dayView)
            }
        }

    private func updateProgressDynamically() {
            let completedDays = dayCheckboxes.filter { $0.isSelected() }.count
            let progress = Float(completedDays) / Float(dayCheckboxes.count)
            updateProgress(progress: progress)
    }

    private func updateProgress(progress: Float) {
        progressBar.setProgress(progress, animated: true)
    }
    
    /*
     private func setupRewards(_ rewards: ChallengeRewards) {
             rewardsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

             let rewardIcons = [
                 ("services", rewards.services),
                 ("environment", rewards.environment),
                 ("entertainment", rewards.entertainment),
                 ("education", rewards.education)
             ]

             for reward in rewardIcons {
                 let rewardView = createRewardView(title: reward.1, iconName: reward.0)
                 rewardsStackView.addArrangedSubview(rewardView)
             }
     }
     
     private func createRewardView(title: String, iconName: String) -> UIView {
             let stackView = UIStackView()
             stackView.axis = .vertical
             stackView.alignment = .center
             stackView.spacing = 4

             let iconImageView = UIImageView(image: UIImage(named: iconName))
             iconImageView.contentMode = .scaleAspectFit
             iconImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
             iconImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true

             let titleLabel = UILabel()
             titleLabel.text = title
             titleLabel.font = UIFont.systemFont(ofSize: 12)
             titleLabel.textAlignment = .center

             stackView.addArrangedSubview(iconImageView)
             stackView.addArrangedSubview(titleLabel)

             return stackView
         }
     */
    
    private func showError(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
}

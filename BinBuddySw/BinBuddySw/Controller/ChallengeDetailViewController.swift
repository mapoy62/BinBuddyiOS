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
    
    @IBOutlet weak var imageChallengeView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var impactLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var shareFBButton: UIButton!
    @IBOutlet weak var shareTwButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet var dayButtons: [UIButton]!
    
    
    
    var challenge: ChallengeEntity?
    var userChallenge: UserChallenge?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadUserChallenge()
    }
    
    
    func setupUI() {
        guard let challenge = challenge else { return }
        
        titleLabel.text = challenge.name
        descLabel.text = challenge.desc
        impactLabel.text = "Impacto Ambiental: \(challenge.impactMetric ?? "None")"
        //TO-DO: AGREGAR TOTAL IMPACT A ENTIDAD
        progressView.progress = min(Float(challenge.impactPerUnit) / 100.0, 1.0) // Ajusta según la lógica de impacto
        
        if let urlString = challenge.imgUrl, let url = URL(string: urlString) {
            imageChallengeView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"), options: .highPriority, completed: { (image, error, cacheType, url) in
                if let error = error {
                    print("Error al cargar la imagen: \(error.localizedDescription)")
                    self.imageChallengeView.image = UIImage(named: "placeholder")
                } else {
                    print("Imagen cargada exitosamente desde: \(url?.absoluteString ?? "URL desconocida")")
                }
            })
        } else {
            imageChallengeView.image = UIImage(named: "placeholder")
            print("URL de imagen inválida para desafío: \(challenge.name ?? "No title found")")
        }
        
        // Configurar apariencia de la vista modal (opcional)
        self.view.backgroundColor = UIColor.white
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true
        
        for button in dayButtons {
                if let dayTitle = button.title(for: .normal),
                   let day = DayOfWeek(rawValue: dayTitle) {
                    button.accessibilityLabel = day.rawValue
                    button.accessibilityTraits = button.isSelected ? [.button, .selected] : [.button]
                }
            }
    }

    func loadUserChallenge() {
            guard let challenge = challenge else { return }
            let context = DataManager.shared.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<UserChallenge> = UserChallenge.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "challenge == %@", challenge)

            do {
                let results = try context.fetch(fetchRequest)
                if let userChallenge = results.first {
                    self.userChallenge = userChallenge
                    updateUIWithUserChallenge()
                } else {
                    let newUserChallenge = UserChallenge(context: context)
                                newUserChallenge.id = UUID()
                                newUserChallenge.challenge = challenge
                                newUserChallenge.daysCompletedSet = Set<DayOfWeek>() // Asignar un Set vacío
                                newUserChallenge.totalImpact = 0.0
                                try context.save()
                                self.userChallenge = newUserChallenge
                                updateUIWithUserChallenge()
                }
            } catch {
                print("Error al cargar UserChallenge: \(error.localizedDescription)")
            }
        }

        func updateUIWithUserChallenge() {
            guard let userChallenge = userChallenge else { return }
            let daysCompleted = userChallenge.daysCompleted

            for button in dayButtons {
                if let day = DayOfWeek(rawValue: button.title(for: .normal) ?? "") {
                    button.isSelected = ((daysCompleted?.value(forKey: day.rawValue)) != nil)
                    updateButtonAppearance(button, isSelected: button.isSelected)
                }
            }

            // Actualizar el progreso basado en totalImpact
            progressView.progress = min(Float(userChallenge.totalImpact) / 100.0, 1.0)
        }
    
    
    @IBAction func dayButtonTapped(_ sender: UIButton) {
        guard let dayTitle = sender.title(for: .normal),
                  let day = DayOfWeek(rawValue: dayTitle) else {
                print("Día no reconocido")
                return
            }

            print("Botón \(day.rawValue) tocado. Estado actual: \(sender.isSelected)")

            if sender.isSelected {
                sender.isSelected = false
                userChallenge?.daysCompletedSet.remove(day)
                // Opcional: Reducir el impacto acumulado si se deselecciona un día
                userChallenge?.totalImpact -= challenge?.impactPerUnit ?? 0.0
                print("Día \(day.rawValue) deseleccionado.")
            } else {
                sender.isSelected = true
                userChallenge?.daysCompletedSet.insert(day)
                // Actualizar el impacto acumulado
                userChallenge?.totalImpact += challenge?.impactPerUnit ?? 0.0
                print("Día \(day.rawValue) seleccionado.")
            }

            updateButtonAppearance(sender, isSelected: sender.isSelected)
            updateProgressView()

            // Guardar los cambios en Core Data
            DataManager.shared.saveContext()
    }
    
    func updateButtonAppearance(_ button: UIButton, isSelected: Bool) {
        let imageName = isSelected ? "largecircle.fill.circle" : "circle"
            let tintColor = isSelected ? UIColor.systemBlue : UIColor.lightGray

            if let image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate) {
                UIView.transition(with: button, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    button.setImage(image, for: .normal)
                    button.tintColor = tintColor
                }, completion: nil)
            } else {
                print("Error: Imagen \(imageName) no encontrada en SF Symbols.")
            }
        }

        func updateProgressView() {
            if let totalImpact = userChallenge?.totalImpact {
                    // Supongamos que el impacto objetivo es 100.0 para el 100%
                    let progress = min(Float(totalImpact) / 100.0, 1.0)
                    progressView.progress = progress

                    // Mostrar porcentaje
                    let percentage = Int(progress * 100)
                    impactLabel.text = "Impacto Ambiental: \(percentage)% (\(totalImpact) \(challenge?.impactMetric ?? ""))"
                }
        }
    
    
    @IBAction func shareFacebookTapped(_ sender: UIButton) {
        share(content: "Estoy participando en el desafío: \(challenge?.name ?? "") #BinBuddySw", image: challenge?.imgUrl != nil ? UIImage(named: "placeholder") : nil)
    }
    
    
    @IBAction func shareTwitterTapped(_ sender: UIButton) {
        share(content: "Estoy participando en el desafío: \(challenge?.name ?? "") #BinBuddySw", image: challenge?.imgUrl != nil ? UIImage(named: "placeholder") : nil)

    }
    
    func share(content: String, image: UIImage?) {
            var items: [Any] = [content]
            if let image = image {
                items.append(image)
            }

            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            activityVC.excludedActivityTypes = [.assignToContact, .addToReadingList, .saveToCameraRoll]

            // Para iPad, configurar el popoverPresentationController
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }

            present(activityVC, animated: true, completion: nil)
        }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true , completion: nil)
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

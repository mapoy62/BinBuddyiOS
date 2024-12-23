//
//  DataManager.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//

import Foundation
import CoreData

class DataManager: NSObject {
    static let shared = DataManager()
    
    private override init() {
        super.init()
    }
    
    // Obtener todas las actividades desde Core Data
    func getAllChallenges() -> [ChallengeEntity] {
        var challenges = [ChallengeEntity]()
        let request = ChallengeEntity.fetchRequest()
        
        do {
            challenges = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error al obtener desafíos: \(error.localizedDescription)")
        }
        
        
        return challenges
    }

    // Llenar la base de datos desde el backend
    func fillDatabase(completion: @escaping () -> Void) {
        let ud = UserDefaults.standard
        if ud.integer(forKey: "DB-LOADED") != 1 {
            if InternetMonitor.shared.isConnected {
                // Llamar al endpoint
                if let getUrl = URL(string: "https://private-66ffc9-binbuddy.apiary-mock.com/activities") {
                    let session = URLSession(configuration: .default)
                    let task = session.dataTask(with: URLRequest(url: getUrl)) { data, response, error in
                        if let error = error {
                            print("No se pudo descargar el feed de Challenges: \(error.localizedDescription)")
                            return
                        }

                        guard let data = data else {
                            print("No se recibieron datos")
                            return
                        }

                        // Parsear y guardar en Core Data
                        do {
                            let decoder = JSONDecoder()
                            let challenges = try decoder.decode([Challenge].self, from: data)
                            self.saveChallenges(challenges)
                            ud.set(1, forKey: "DB-LOADED")
                            completion()
                        } catch {
                            print("No se pudo parsear el feed de Challenges: \(error.localizedDescription)")
                        }
                    }
                    task.resume()
                }
            }
        } else {
            completion()
        }
    }

    // Guardar desafíos en Core Data
    func saveChallenges(_ challenges: [Challenge]) {
        let context = persistentContainer.viewContext

        
        for challenge in challenges {
            // Verificar si el desafío ya existe para evitar duplicados
            let fetchRequest: NSFetchRequest<ChallengeEntity> = ChallengeEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", challenge.id)

            do {
                let results = try context.fetch(fetchRequest)
                if results.isEmpty {
                    // Crear un nuevo objeto ChallengeEntity
                    let newChallenge = ChallengeEntity(context: context)
                    newChallenge.id = Int16(challenge.id)
                    newChallenge.name = challenge.name
                    newChallenge.desc = challenge.description
                    newChallenge.points = challenge.points
                    newChallenge.categoryId = Int16(challenge.categoryId)
                    newChallenge.impactMetric = challenge.impactMetric
                    newChallenge.impactPerUnit = challenge.impactPerUnit
                    newChallenge.imgUrl = challenge.imgUrl
                } else {
                    // Actualizar el desafío existente si es necesario
                    // Por ahora, omitiremos la actualización
                    continue
                }
            } catch {
                print("Error al buscar desafío con id \(challenge.id): \(error.localizedDescription)")
            }
         
        }

        // Guardar el contexto
        saveContext()
    }

    // Acceso al Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BinBuddySw")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // Guardar el contexto
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

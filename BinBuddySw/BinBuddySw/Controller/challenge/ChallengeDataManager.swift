//
//  ChallengeDataManager.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 11/01/25.
//

import Foundation

import Foundation

class ChallengeDataManager {
    static let shared = ChallengeDataManager()
    private let challengesKey = "challenges"

    private init() {}

    // Guardar desafíos localmente
    func saveChallenges(_ challenges: [Challenge]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(challenges) {
            UserDefaults.standard.set(encoded, forKey: challengesKey)
        }
    }

    // Cargar desafíos desde almacenamiento local
    func loadChallenges() -> [Challenge]? {
        if let savedData = UserDefaults.standard.data(forKey: challengesKey) {
            let decoder = JSONDecoder()
            return try? decoder.decode([Challenge].self, from: savedData)
        }
        return nil
    }

    // Obtener desafíos desde el backend
    func fetchChallenges(completion: @escaping (Result<[Challenge], Error>) -> Void) {
        let url = URL(string: "https://private-66ffc9-binbuddy.apiary-mock.com/challenges")! // Cambia por tu URL real

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No se recibieron datos"])
                completion(.failure(error))
                return
            }

            do {
                let decoder = JSONDecoder()
                let challenges = try decoder.decode([Challenge].self, from: data)
                self.saveChallenges(challenges) // Guarda localmente
                completion(.success(challenges))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}



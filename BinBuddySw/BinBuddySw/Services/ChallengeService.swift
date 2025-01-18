//
//  ChallengeService.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 11/01/25.
//

import Foundation

class ChallengeService {
    static let shared = ChallengeService() // Patrón Singleton

    

    func fetchChallenges(completion: @escaping (Result<[Challenge], Error>) -> Void) {
        let url = URL(string: "https://private-66ffc9-binbuddy.apiary-mock.com/challenges")!

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error de red: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("Error: No se recibió data")
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No se recibieron datos"])
                completion(.failure(error))
                return
            }

            do {
                print("Datos recibidos: \(String(data: data, encoding: .utf8) ?? "No se pueden mostrar los datos como string")")
                let decoder = JSONDecoder()
                let challenges = try decoder.decode([Challenge].self, from: data)
                completion(.success(challenges))
            } catch {
                print("Error al decodificar JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    
    //https://private-66ffc9-binbuddy.apiary-mock.com/challenge/\(id)
    static func fetchChallengeDetails(by id: Int, completion: @escaping (Result<ChallengeDetail, Error>) -> Void) {
        let urlString = "https://private-66ffc9-binbuddy.apiary-mock.com/challenge/\(id)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON recibido: \(jsonString)")
                }
            
            do {
                let challengeDetail = try JSONDecoder().decode(ChallengeDetail.self, from: data)
                completion(.success(challengeDetail))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


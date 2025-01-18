//
//  RewardService.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 13/01/25.
//

import Foundation

class RewardService {
    private let baseUrl = "https://private-66ffc9-binbuddy.apiary-mock.com/rewards"
    static func fetchRewards(completion: @escaping (Result<[Reward], Error>) -> Void) {
        let urlString = "https://private-66ffc9-binbuddy.apiary-mock.com/rewards"
        guard let url = URL(string: urlString) else {
                    completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                    return
                }

                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    guard let data = data else {
                        completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                        return
                    }

                    // Imprimir el JSON recibido para depuración
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("JSON recibido: \(jsonString)")
                    }

                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase // Por si hay nombres con snake_case
                        let rewards = try decoder.decode([Reward].self, from: data)
                        completion(.success(rewards))
                    } catch {
                        print("Error al decodificar JSON: \(error)")
                        completion(.failure(error))
                    }
                }.resume()
            }
}


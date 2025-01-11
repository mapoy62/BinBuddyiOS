//
//  EventService.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 10/01/25.
//

import Foundation

class EventService {
    func fetchImageLinks(completion: @escaping (Result<[String], Error>) -> Void) {
        let urlString = "https://private-66ffc9-binbuddy.apiary-mock.com/events/banner"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }

            do {
                // Decodificar directamente los enlaces de las imágenes
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                let links = json?.compactMap { $0["link"] as? String } ?? []
                completion(.success(links))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}


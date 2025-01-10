//
//  RecyclingEventService.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 10/01/25.
//

import Foundation

class RecyclingEventService {
    func fetchRecyclingEvents(completion: @escaping (Result<[RecyclingEvent], Error>) -> Void) {
        let urlString = "https://private-66ffc9-binbuddy.apiary-mock.com/events"
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
                let events = try JSONDecoder().decode([RecyclingEvent].self, from: data)
                completion(.success(events))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    
}


//
//  InstagramService.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 09/01/25.
//

import Foundation

class InstagramService {
    func fetchInstagramProfiles(completion: @escaping (Result<[InstagramProfile], Error>) -> Void) {
        let urlString = "https://private-66ffc9-binbuddy.apiary-mock.com/igprofile"
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
                let profiles = try JSONDecoder().decode([InstagramProfile].self, from: data)
                completion(.success(profiles))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

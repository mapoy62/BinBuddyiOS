//
//  TwitterService.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 08/01/25.
//

import Foundation
import UIKit

class TwitterService {
    private let bearerToken = "AAAAAAAAAAAAAAAAAAAAALDCxgEAAAAAYNUbPmZlwtHYl0xrD%2BIrNRunXlI%3DMQcIEwWRk4hhINjdmSP8I7Lr20MyQw1GZclUZAIW1r6WXjJ2Ay"

    func fetchTweets(with hashtag: String, maxResults: Int = 10, completion: @escaping (Result<[Tweet], Error>) -> Void) {
            let urlString = "https://api.twitter.com/2/tweets/search/recent?query=%23\(hashtag)&max_results=\(maxResults)"
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                return
            }

            var request = URLRequest(url: url)
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                    return
                }

                do {
                    let tweetResponse = try JSONDecoder().decode(TweetResponse.self, from: data)
                    
                    if let tweets = tweetResponse.data {
                        completion(.success(tweets))
                    } else {
                        completion(.failure(NSError(domain: "NoDataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No tweets found"])))
                    }
                } catch {
                    print("Error al decodificar: \(error.localizedDescription)")
                    completion(.failure(error))
                }

            }

            task.resume()
        }
    
    func fetchTweetImage(from url: String, completion: @escaping (UIImage?) -> Void) {
            guard let imageURL = URL(string: url) else {
                completion(nil)
                return
            }
            URLSession.shared.dataTask(with: imageURL) { data, _, error in
                if let data = data, error == nil {
                    completion(UIImage(data: data))
                } else {
                    completion(nil)
                }
            }.resume()
    }
}


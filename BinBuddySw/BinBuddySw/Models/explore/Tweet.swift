//
//  Tweet.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 08/01/25.
//

import Foundation

struct TweetResponse: Codable {
    let data: [Tweet]?
}

struct Tweet: Codable, Identifiable {
    let id: String
    var text: String
}

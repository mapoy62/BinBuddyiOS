//
//  ChallengeDetail.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 11/01/25.
//

import Foundation

struct ChallengeDetail: Decodable {
    let id: Int
    let name: String
    let description: String
    let imgUrl: String?
    let progress: Float?
    let rewards: Rewards?
}

struct Rewards: Decodable {
    let services: String?
    let environment: String?
    let entertainment: String?
    let education: String?
}



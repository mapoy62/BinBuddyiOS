//
//  Reward.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 13/01/25.
//

import Foundation

struct Reward: Decodable {
    let id: String
    let name: String
    let description: String
    let rewardType: String
    let value: Int?
    let conditions: Conditions?
    let category: String
    let validity: Validity?
    let isRedeemed: Bool
    let imageUrl: String?
    let createdAt: String?
    let updatedAt: String?
}

struct Conditions: Decodable {
    let completedChallenges: Int?
}

struct Validity: Decodable {
    let start: String?
    let end: String?
}




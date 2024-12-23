//
//  Challenge.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//

import Foundation

struct Challenge: Codable {
    let id: Int
    let name: String
    let description: String
    let points: Double
    let categoryId: Int
    let impactMetric: String
    let impactPerUnit: Double
    let imgUrl: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case points
        case categoryId
        case impactMetric
        case impactPerUnit
        case imgUrl
    }
}

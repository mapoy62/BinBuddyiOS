//
//  RecyclingEvent.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 10/01/25.
//

import Foundation

struct RecyclingEvent: Codable {
    let id: Int
    let name: String
    let description: String
    let date: String
    let points: Int?
    let locationLat: Double
    let locationLong: Double
    
    //Convertir String del JSON a Date
    var eventDate: Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: date)
    }
}


//
//  ChallengeEntity+CoreDataProperties.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//
//

import Foundation
import CoreData


extension ChallengeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChallengeEntity> {
        return NSFetchRequest<ChallengeEntity>(entityName: "ChallengeEntity")
    }

    @NSManaged public var categoryId: Int16
    @NSManaged public var desc: String?
    @NSManaged public var id: Int16
    @NSManaged public var imgUrl: String?
    @NSManaged public var impactMetric: String?
    @NSManaged public var impactPerUnit: Double
    @NSManaged public var name: String?
    @NSManaged public var points: Double
    @NSManaged public var challenge: UserChallenge?

}

extension ChallengeEntity : Identifiable {

}

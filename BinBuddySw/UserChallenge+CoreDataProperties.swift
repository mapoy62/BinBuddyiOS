//
//  UserChallenge+CoreDataProperties.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//
//

import Foundation
import CoreData


extension UserChallenge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserChallenge> {
        return NSFetchRequest<UserChallenge>(entityName: "UserChallenge")
    }

    @NSManaged public var daysCompleted: NSObject?
    @NSManaged public var id: UUID?
    @NSManaged public var totalImpact: Double
    @NSManaged public var challenge: ChallengeEntity?

}

extension UserChallenge : Identifiable {

}

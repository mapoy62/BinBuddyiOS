//
//  UserChallenge+Extension.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//

import Foundation
import CoreData

extension UserChallenge {

    var daysCompletedSet: Set<DayOfWeek> {
        get {
            return daysCompleted as? Set<DayOfWeek> ?? Set<DayOfWeek>()
        }
        set {
            daysCompleted = newValue as NSObject
        }
    }
}

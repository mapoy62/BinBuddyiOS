//
//  DaysOfWeekTransformer.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 21/12/24.
//

import Foundation

@objc(DaysOfWeekTransformer)
class DaysOfWeekTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? Set<DayOfWeek> else { return nil }
        do {
            let data = try JSONEncoder().encode(Array(days))
            return data
        } catch {
            print("Error al transformar daysCompleted: \(error)")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            let daysArray = try JSONDecoder().decode([DayOfWeek].self, from: data)
            return Set(daysArray)
        } catch {
            print("Error al revertir daysCompleted: \(error)")
            return nil
        }
    }
}

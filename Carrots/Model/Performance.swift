//
//  Performance.swift
//  Carrots
//
//  Created by Benjamin Breton on 27/04/2021.
//

import Foundation
import CoreData
/*
 class FakePerformance {
     let sport: FakeSport?
     let value: Int64
     let potAddings: Int
     let addedToCommonPot: Bool
     let athletics: [FakeAthletic]?
     let date: Date? = Date()
     var formattedDate: String {
         let formatter = DateFormatter()
         formatter.locale = Locale.current
         formatter.dateStyle = .long
         formatter.timeStyle = .medium
         guard let date = date else { return "" }
         return formatter.string(from: date)
     }
     init(sport: FakeSport, athletics: [FakeAthletic], value: Int64, addedToCommonPot: Bool) {
         self.sport = sport
         self.athletics = athletics
         self.value = value
         self.addedToCommonPot = addedToCommonPot
         potAddings = Int(value) / Int(sport.valueForOnePoint)
     }
 }
 */
public class Performance: NSManagedObject {
    var athletics: [Athletic] {
        guard let athleticsSet = athleticsSet, let athletics = athleticsSet.allObjects as? [Athletic] else {
            return []
        }
        return athletics
    }
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        guard let date = date else { return "" }
        return formatter.string(from: date)
    }
    
    /// Add points earned with a performance to pot depending on performance's parameters.
    /// - parameter performance: Performance with which points have been earned.
    func addPoints(to pots: [Pot?]) {
        for optionalPot in pots {
            if let pot = optionalPot {
                pot.addPoints(potAddings)
            }
        }
    }
    /// Cancel points added in pots by a performance.
    /// - parameter performance: Performance which added points.
    func cancelPoints(to pots: [Pot?]) {
        for optionalPot in pots {
            if let pot = optionalPot {
                pot.addPoints(-potAddings)
            }
        }
    }
}

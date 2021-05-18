//
//  Performance.swift
//  Carrots
//
//  Created by Benjamin Breton on 27/04/2021.
//

import Foundation
import CoreData
public class Performance: NSManagedObject {
    public override var description: String { "\(formattedDate) performance" }
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
    func addPoints(to pots: [Pot?], with pointsForOneEuro: Int, for predictionDate: Date) {
        for optionalPot in pots {
            if let pot = optionalPot {
                pot.changePoints(Int(potAddings), with: pointsForOneEuro, for: predictionDate)
            }
        }
    }
    /// Cancel points added in pots by a performance.
    /// - parameter performance: Performance which added points.
    func cancelPoints(to pots: [Pot?], with pointsForOneEuro: Int, for predictionDate: Date) {
        for optionalPot in pots {
            if let pot = optionalPot {
                pot.changePoints(-Int(potAddings), with: pointsForOneEuro, for: predictionDate)
            }
        }
    }
}

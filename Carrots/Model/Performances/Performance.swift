//
//  Performance.swift
//  Carrots
//
//  Created by Benjamin Breton on 27/04/2021.
//

import Foundation
import CoreData
public class Performance: NSManagedObject {
    
    var formattedValue: String {
        let unity = initialUnity.sportUnityType
        return unity != .oneShot ? "\(unity.singleString(for: value))" : "performances.oneShot".localized
    }
    
    public override var description: String { "\(formattedDate) performance" }
    var athletics: [Athletic] {
        guard let athleticsSet = athleticsSet, let athletics = athleticsSet.allObjects as? [Athletic] else {
            return []
        }
        return athletics.sorted {
            $0.name ?? "all.noName".localized < $1.name ?? "all.noName".localized
        }
    }
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        guard let date = date else { return "" }
        return formatter.string(from: date)
    }
    /**
     Add points earned with a performance to pots depending on performance's parameters.
     - parameter pots: Pots in which the points have to be added.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     - parameter predictionDate: Setted date to predict a pot's amount.
     */
    func addPoints(to pots: [Pot?], with moneyConversion: Int, for predictionDate: Date) {
        for optionalPot in pots {
            if let pot = optionalPot {
                pot.changePoints(Int(potAddings), with: moneyConversion, for: predictionDate)
            }
        }
    }
    /// Cancel points added in pots by a performance.
    /// - parameter performance: Performance which added points.
    /// - parameter moneyConversion: Necessary number of points to get one money's unity.
    /// - parameter predictionDate: Setted date to predict a pot's amount.
    func cancelPoints(to pots: [Pot?], with moneyConversion: Int, for predictionDate: Date) {
        for optionalPot in pots {
            if let pot = optionalPot {
                pot.changePoints(-Int(potAddings), with: moneyConversion, for: predictionDate)
            }
        }
    }
}

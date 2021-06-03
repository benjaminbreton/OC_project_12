//
//  Performance.swift
//  Carrots
//
//  Created by Benjamin Breton on 27/04/2021.
//

import Foundation
import CoreData
final public class Performance: NSManagedObject {
    
    // MARK: - Properties
    
    /// Performance's description, aka its date.
    public override var description: String { "\(formattedDate) performance" }
    /// Formatted value of the performance.
    var formattedValue: String {
        guard let sport = sport else { return "" }
        return "\(initialUnity.sportUnityType.singleString(for: initialUnity.sportUnityType == Sport.UnityType.oneShot ? sport.pointsConversion : value))"
    }
    /// Athletics who did participate to the performance.
    var athletics: [Athletic] {
        return athleticsSet.getArray().sorted {
            $0.description < $1.description
        }
    }
    /// Formatted performance's date.
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        guard let date = date else { return "" }
        return formatter.string(from: date)
    }
    
    // MARK: - Methods
    
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

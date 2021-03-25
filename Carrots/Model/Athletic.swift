//
//  Athletic.swift
//  Carrots
//
//  Created by Benjamin Breton on 25/03/2021.
//

import Foundation
import CoreData
public class Athletic: NSManagedObject {
    var allPoints: Double {
        guard let performancesSet = performances, let performances = performancesSet.allObjects as? [Performance] else {
            return 0
        }
        if performances.count > 0 {
            return performances.map({ $0.addedToCommonPot ? 0 : $0.potAddings }).reduce(0, +)
        } else {
            return 0
        }
    }
    
}

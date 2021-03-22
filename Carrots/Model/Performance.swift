//
//  Performance.swift
//  Carrots
//
//  Created by Benjamin Breton on 22/03/2021.
//

import Foundation
import CoreData
public class Performance: NSManagedObject {
    var points: Double {
        guard let sport = sport else { return 0 }
        let points = round(value / sport.valueForOnePoint)
        return points * sport.valueForOnePoint > value ? points - 1 : points
    }
}

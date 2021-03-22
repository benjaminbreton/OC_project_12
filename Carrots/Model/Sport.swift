//
//  Sport.swift
//  Carrots
//
//  Created by Benjamin Breton on 22/03/2021.
//

import Foundation
import CoreData
public class Sport: NSManagedObject {
    /// Sport's unity type.
    var unityType: UnityType {
        switch unityInt16 {
        case 1:
            return .kilometers
        case 2:
            return .time
        default:
            return .count
        }
    }
    func pointsToAdd(value: Double) -> Double {
        let points = round(value / valueForOnePoint)
        return points * valueForOnePoint > value ? points - 1 : points
    }
    /// Sport's unity type enumeration.
    enum UnityType {
        case kilometers, time, count
        /// Sport's unity type int16 to save in coredata.
        var int16: Int16 {
            switch self {
            case .kilometers:
                return 1
            case .time:
                return 2
            case .count:
                return 0
            }
        }
        func value(for value: [Double]) -> Double {
            switch self {
            case .time:
                return value[0] * 3600 + value[1] * 60 + value[2]
            default:
                return value[0]
            }
        }
    }
    
    
}

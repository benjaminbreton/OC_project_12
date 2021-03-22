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
    }
}

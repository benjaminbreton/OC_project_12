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
    var unityType: UnityType { unityInt16.sportUnityType }
    func pointsToAdd(value: Double) -> Double {
        let points = round(value / valueForOnePoint)
        return points * valueForOnePoint > value ? points - 1 : points
    }
    /// Sport's unity type enumeration.
    enum UnityType: HashableCustomString {
        
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
        var description: String {
            switch self {
            case .kilometers:
                return "kilometers"
            case .time:
                return "time"
            case .count:
                return "count"
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
        func stringArray(for value: Int64) -> [String] {
            switch self {
            case .time:
                let interval = TimeInterval(value)
                let components = DateComponents(calendar: Calendar.current, year: 0, month: 0, day: 0, hour: 0, minute: 0, second: 0)
                guard let firstDate = components.date else { return ["0", "0", "0"]}
                let date = Date(timeInterval: interval, since: firstDate)
                let neededComponents: Set<Calendar.Component> = [.hour, .minute, .second]
                
                let resultComponents = Calendar.current.dateComponents(neededComponents, from: date)
                guard let hours = resultComponents.hour, let minutes = resultComponents.minute, let seconds = resultComponents.second else { return ["0", "0", "0"]}
                return ["\(hours)", "\(minutes)", "\(seconds)"]
            default:
                return ["\(Int(value))"]
            }
        }
        func singleString(for value: Int64) -> String {
            let realisation = stringArray(for: value)
            switch self {
            case .time:
                return "\(realisation[0]) h \(realisation[1]) m \(realisation[2]) s"
            case .kilometers:
                return "\(realisation[0]) km"
            default:
                return realisation[0]
            }
        }
        
    }
    
    
    
    
}


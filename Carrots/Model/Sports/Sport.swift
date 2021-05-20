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
    var performances: [Performance] {
        guard let performancesSet = performancesSet, let performances = performancesSet.allObjects as? [Performance] else {
            return []
        }
        return performances
    }
    override public var description: String { name ?? "No name" }
    func pointsToAdd(for value: Int64) -> Int64 {
        guard valueForOnePoint > 0 else { return 0 }
        switch unityInt16.sportUnityType {
        case .oneShot:
            return valueForOnePoint
        default:
            let points = value / valueForOnePoint
            return points * valueForOnePoint > value ? points - 1 : points
        }
    }
    func update(name: String?, icon: String?, unityType: Int16?, valueForOnePoint: [String?]) {
        guard let name = name, let icon = icon, let unityType = unityType else { return }
        self.name = name
        self.icon = icon
        self.unityInt16 = unityType
        self.valueForOnePoint = self.unityType.value(for: valueForOnePoint)
    }
    /// Sport's unity type enumeration.
    enum UnityType: CustomStringConvertible {
        
        case distance, time, count, oneShot
        
        /// Sport's unity type int16 to save in coredata.
        var int16: Int16 {
            switch self {
            case .distance:
                return 1
            case .time:
                return 2
            case .oneShot:
                return 3
            case .count:
                return 0
            }
        }
        var description: String {
            switch self {
            case .distance:
                return "distance"
            case .time:
                return "time"
            case .oneShot:
                return "one shot"
            case .count:
                return "count"
            }
        }
        var symbols: [String] {
            switch self {
            case .distance:
                return [" km"]
            case .time:
                return [" h ", " m ", " s"]
            case .oneShot:
                return [" pts"]
            default:
                return [""]
            }
        }
        var placeholders: [String] {
            switch self {
            case .distance:
                return ["distance"]
            case .time:
                return ["hours", "min.", "sec."]
            case .oneShot:
                return ["earned points"]
            case .count:
                return ["count"]
            }
        }
        var explanations: String {
            switch self {
            case .distance:
                return "You have to indicate here the necessary distance to reach to get one point."
            case .time:
                return "You have to indicate here the necessary exercice's duration to get one point."
            case .count:
                return "You have to indicate here the necessary count to get one point."
            case .oneShot:
                return "You have to indicate here the number of points earned each time this sport has been made. "
            }
        }
        func value(for inputs: [String?]) -> Int64 {
            guard inputs.count == 3 else { return 0 }
            let values: [Int] = inputs.map({ Int($0 ?? "0") ?? 0 })
            switch self {
            case .time:
                return Int64(values[0] * 3600 + values[1] * 60 + values[2])
            default:
                return Int64(values[0])
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
                return ["\(Int(value))", "0", "0"]
            }
        }
        func singleString(for value: Int64) -> String {
            let realisation = stringArray(for: value)
            switch self {
            case .time:
                return "\(realisation[0])\(symbols[0])\(realisation[1])\(symbols[1])\(realisation[2])\(symbols[2])"
            case .distance, .oneShot:
                return "\(realisation[0])\(symbols[0])"
            default:
                return realisation[0]
            }
        }
        
    }
    
    
    
    
}


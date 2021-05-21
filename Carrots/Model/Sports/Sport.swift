//
//  Sport.swift
//  Carrots
//
//  Created by Benjamin Breton on 22/03/2021.
//

import Foundation
import CoreData

// MARK: - Properties

public class Sport: NSManagedObject {
    
    /// Sport's unity type.
    var unityType: UnityType { unityInt16.sportUnityType }
    /// Sport's performances.
    var performances: [Performance] {
        guard let performancesSet = performancesSet, let performances = performancesSet.allObjects as? [Performance] else {
            return []
        }
        return performances
    }
    /// Sport's description, aka its name.
    override public var description: String { name ?? "all.noName".localized }
    /// Get the points conversion in an array of Strings regarding the unity type.
    var pointsConversionStringArray: [String] { unityType.stringArray(for: pointsConversion) }
    /// Get the points conversion in a single String regarding the unity type.
    var pointsConversionSingleString: String { unityType.singleString(for: pointsConversion) }
    
}

// MARK: - Points

extension Sport {
    
    /**
     Get the points to add regarding the performance's value and the unity type.
     - parameter value: Performance's value.
     - returns: Points to add.
     */
    func pointsToAdd(for value: Int64) -> Int64 {
        guard pointsConversion > 0 else { return 0 }
        switch unityType {
        case .oneShot:
            return pointsConversion
        default:
            let points = value / pointsConversion
            return points * pointsConversion > value ? points - 1 : points
        }
    }
}

// MARK: - Update

extension Sport {
    /**
     Update the sport.
     - parameter name: Sport's name.
     - parameter icon: Sport's icon's character.
     - parameter unityType: The unity used to measure a sport's performance (Int16 format, property int16 of Sport.UnityType).
     - parameter pointsConversion: The needed performance's value to get one point, or the earned points each time this sport has been made.
     - returns: If an error occurred, the error's type is returned.
     */
    func update(name: String, icon: String, unityType: Int16, pointsConversion: [String?]) {
        self.name = name
        self.icon = icon
        self.unityInt16 = unityType
        self.pointsConversion = self.unityType.value(for: pointsConversion)
    }
}

// MARK: - Unity types

extension Sport {

    enum UnityType: CustomStringConvertible {
        
        // MARK: - Cases
        
        case distance, time, count, oneShot
        
        // MARK: - Properties
        
        /// Key base to get a string from the localizable files.
        var localizedKey: String {
            let base = "sports.unityType."
            switch self {
            case .distance:
                return "\(base)distance."
            case .time:
                return "\(base)time."
            case .oneShot:
                return "\(base)oneShot."
            case .count:
                return "\(base)count."
            }
        }
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
        /// Description of the type.
        var description: String {
            "\(localizedKey)description".localized
        }
        /// Symbols to use for displaying a value.
        var symbols: [String] {
            switch self {
            case .time:
                return ["\(localizedKey)symbols1".localized, "\(localizedKey)symbols2".localized, "\(localizedKey)symbols3".localized]
            default:
                return ["\(localizedKey)symbols1".localized]
            }
        }
        /// Placeholders to use to ask a value.
        var placeholders: [String] {
            switch self {
            case .time:
                return ["\(localizedKey)placeholder1".localized, "\(localizedKey)placeholder2".localized, "\(localizedKey)placeholder3".localized]
            default:
                return ["\(localizedKey)placeholder1".localized]
            }
        }
        /// Types explanations to display.
        var explanations: String {
            "\(localizedKey)explanations".localized
        }
        
        // MARK: - Methods
        
        /**
         Get an Int64 value from Strings.
         - parameter inputs: Strings to convert.
         - returns: The Int64.
         */
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
        /**
         Get an array of Strings from an Int64.
         - parameter value: The Int64.
         - returns: The array of Strings.
         */
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
        /**
         Get a single, formatted, String from an Int64 value.
         - parameter value: The Int64 value to convert.
         - returns: The String.
         */
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

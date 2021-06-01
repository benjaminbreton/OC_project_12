//
//  Sport.swift
//  Carrots
//
//  Created by Benjamin Breton on 22/03/2021.
//

import Foundation
import CoreData

// MARK: - Properties

final public class Sport: NSManagedObject {
    
    /// Sport's unity type.
    var unityType: UnityType { unityInt16.sportUnityType }
    /// Sport's performances.
    var performances: [Performance] {
        performancesSet.getArray().sorted() {
            $0.date.unwrapped > $1.date.unwrapped
        }
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
            return value / pointsConversion
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
            let values: [Int64] = inputs.map({ $0.int64 })
            switch self {
            case .time:
                return values[0] * 3600 + values[1] * 60 + values[2]
            default:
                return values[0]
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
                let hours = value / 3600
                let valueRemaining = value % 3600
                let minutes = valueRemaining / 60
                let seconds = valueRemaining % 60
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
                return "\(getHours(of: realisation))\(getMinutes(of: realisation))\(getSeconds(of: realisation))"
            case .distance, .oneShot:
                return "\(realisation[0])\(symbols[0])"
            default:
                return realisation[0]
            }
        }
        /**
         Get hours of a time's string array.
         - parameter strings : The string array.
         - returns: The hours string.
         */
        private func getHours(of strings: [String]) -> String {
            return getTimeElement(of: strings, at: 0, isFirstElement: true)
        }
        /**
         Get minutes of a time's string array.
         - parameter strings : The string array.
         - returns: The minutes string.
         */
        private func getMinutes(of strings: [String]) -> String {
            return getTimeElement(of: strings, at: 1, isFirstElement: strings[0] == "0")
        }
        /**
         Get seconds of a time's string array.
         - parameter strings : The string array.
         - returns: The seconds string.
         */
        private func getSeconds(of strings: [String]) -> String {
            return getTimeElement(of: strings, at: 2, isFirstElement: false)
        }
        /**
         Get a time element (hours, minutes or seconds) of a time's string array.
         - parameter strings : The string array.
         - parameter index: The element's index in the array.
         - parameter isFirstElement: Boolean indicating whether this element will be the first in the final string or not.
         - returns: The element's string.
         */
        private func getTimeElement(of strings: [String], at index: Int, isFirstElement: Bool) -> String {
            return strings[index] == "0" ?
                ""
                :
                strings[index].count == 1 && !isFirstElement ?
                "0\(strings[index])\(symbols[index])"
                :
                "\(strings[index])\(symbols[index])"
        }
    }
}



//
//  Settings.swift
//  Carrots
//
//  Created by Benjamin Breton on 30/03/2021.
//

import Foundation
struct Settings {
    /// Needed points to get one euro.
    @UserDefault(key: "pointsForOneEuro", defaultValue: 100)
    var pointsForOneEuro: Int
    /// Indicates whether introduction has been seen or not.
    @UserDefault(key: "didSeeIntroduction", defaultValue: false)
    var didSeeIntroduction: Bool
    /// Indicates whether game has to be created from scratch or if some datas exist.
    @UserDefault(key: "gameAlreadyExists", defaultValue: false)
    var gameAlreadyExists: Bool
    /// Date used to get statistics.
    @UserDefault(key: "predictedAmountDate", defaultValue: Date() - 24 * 3600)
    var predictedAmountDate: Date
    private var days: Double {
        #if DAYSAGO45
            return 45
        #elseif DAYSAGO31
            return 31
        #elseif DAYSAGO20
            return 20
        #elseif DAYSAGO18
            return 18
        #elseif DAYSAGO12
            return 12
        #elseif DAYSAGO05
            return 5
        #else
            return 0
        #endif
    }
    var today: Date { Calendar.current.startOfDay(for: now) }
    var now: Date { Date() - days * 24 * 3600 }
    init() {
        if predictedAmountDate < today {
            predictedAmountDate = today + 30 * 24 * 3600
        }
    }
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var wrappedValue: Value {
        get {
            UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}


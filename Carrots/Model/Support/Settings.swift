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
    var predictionDate: Date
    /// Boolean used to know if help has to be shown or not.
    @UserDefault(key: "showHelp", defaultValue: true)
    var showHelp: Bool
    init() {
        if predictionDate < Date().today {
            predictionDate = Date().today + 30 * 24 * 3600
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


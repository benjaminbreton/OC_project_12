//
//  Settings.swift
//  Carrots
//
//  Created by Benjamin Breton on 30/03/2021.
//

import Foundation
struct Settings {
    /// Necessary number of points to get one money's unity.
    @UserDefault(key: "moneyConversion", defaultValue: 100)
    var moneyConversion: Int
    /// Indicates whether game has to be created from scratch or if some datas exist.
    @UserDefault(key: "gameAlreadyExists", defaultValue: false)
    var gameAlreadyExists: Bool
    /// Setted date to predict a pot's amount.
    @UserDefault(key: "predictionDate", defaultValue: Date() - 24 * 3600)
    var predictionDate: Date
    /// Boolean used to know if help has to be shown or not.
    @UserDefault(key: "showHelp", defaultValue: true)
    var showHelp: Bool
    /// Boolean used to know if pot's warning has been validated.
    @UserDefault(key: "didValidateWarning", defaultValue: false)
    var didValidateWarning: Bool
    
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


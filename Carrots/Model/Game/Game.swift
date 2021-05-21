//
//  Game.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/03/2021.
//

import Foundation
import CoreData

// MARK: - Properties

struct Game {
    /// Game's settings saved in Userdefaults.
    private(set) var settings: Settings
    /// Coredatastack used to save and load datas from CoreData.
    private let coreDataStack: CoreDataStack
    /// All  registered athletics.
    private(set) var athletics: [Athletic]
    /// All registered sports.
    private(set) var sports: [Sport]
    /// All registered performances.
    private(set) var performances: [Performance]
    /// Pot used as common pot.
    private(set) var commonPot: Pot?
    /// Error.
    private var error: ApplicationErrors?
    /// Class managing athletics creation, modification and deletion
    private let athleticsManager: AthleticsManager
    /// Class managing sports creation, modification and deletion
    private let sportsManager: SportsManager
    /// Class managing performances creation, modification and deletion
    private let performancesManager: PerformancesManager
    /// Class managing pots creation, modification and deletion
    private let potsManager: PotsManager
}

// MARK: - Init

extension Game {
    /// Create game with the entered Coredatastack.
    /// - parameter coreDataStack: Coredatastack used to save and load datas from CoreData (Coredatastack() by default).
    init(coreDataStack: CoreDataStack = CoreDataStack()) {
        // load settings
        self.settings = Settings()
        // get CoreDataStack
        self.coreDataStack = coreDataStack
        // set default properties
        athletics = []
        sports = []
        performances = []
        athleticsManager = AthleticsManager(coreDataStack)
        sportsManager = SportsManager(coreDataStack)
        performancesManager = PerformancesManager(coreDataStack)
        potsManager = PotsManager(coreDataStack)
        commonPot = coreDataStack.entities.commonPot
        if commonPot == nil { commonPot = potsManager.create() }
        settings.gameAlreadyExists = true
        // load game
        refresh()
    }
}

// MARK: - Refresh

extension Game {
    
    /**
     Refresh all properties.
     */
    mutating func refresh() {
        guard error == nil else { return }
        athletics = coreDataStack.entities.allAthletics
        performances = coreDataStack.entities.allPerformances
        sports = coreDataStack.entities.allSports
        potsManager.refresh(with: settings.moneyConversion, for: settings.predictionDate)
        athleticsManager.refresh()
        coreDataStack.saveContext()
    }
}

// MARK: - Athletics

extension Game {
    
    /**
     Add athletic.
     - parameter name: Athletic's name.
     - parameter image: Athletic's image's data.
     */
    mutating func addAthletic(name: String?, image: Data?) {
        guard let name = name else { return }
        let today = Date().now
        let pot = potsManager.create(for: today)
        error = athleticsManager.add(name: name, image: image, pot: pot, creationDate: today)
        refresh()
    }
    /**
     Modify an athletic.
     - parameter athletic : Athletic to modify.
     - parameter name: Athletic's name.
     - parameter image: Athletic's image's data.
     */
    mutating func modify(_ athletic: Athletic, name: String?, image: Data?){
        guard let name = name else { return }
        error = athleticsManager.modify(athletic, name: name, image: image)
        refresh()
    }
    /**
     Delete an athletic.
     - parameter athletic: Athletic to delete.
     */
    mutating func delete(_ athletic: Athletic) {
        error = athleticsManager.delete(athletic)
        refresh()
    }
}

// MARK: - Settings

extension Game {
    /**
     Settings modification.
     - parameter predictionDate: Setted date to predict a pot's amount.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     - parameter showHelp: Boolean which indicates if help texts have to be shown or not.
     */
    mutating func updateSettings(predictionDate: Date, moneyConversion: String?, showHelp: Bool) {
        guard let points = moneyConversion, points.count < 5, let intPoints = Int(points) else { return }
        settings.predictionDate = predictionDate
        settings.moneyConversion = intPoints
        settings.showHelp = showHelp
        potsManager.refresh(with: intPoints, for: predictionDate)
    }
    /**
     Validate pots warning, so that the warning will not appear again.
     */
    mutating func validateWarning() {
        settings.didValidateWarning = true
    }
}

// MARK: - Sports

extension Game {
    /**
     Add sport.
     - parameter name: Sport's name.
     - parameter icon: Sport's icon's character.
     - parameter unityType: The unity used to measure a sport's performance.
     - parameter pointsConversion: The needed performance's value to get one point, or the earned points each time this sport has been made.
     */
    mutating func addSport(name: String?, icon: String?, unityType: Sport.UnityType?, pointsConversion: [String?]) {
        guard let name = name, let icon = icon, let unityType = unityType else { return }
        error = sportsManager.add(name: name, icon: icon, unityType: unityType, pointsConversion: pointsConversion)
        refresh()
    }
    /**
     Modify sport.
     - parameter sport: The sport to modify.
     - parameter name: Sport's name.
     - parameter icon: Sport's icon's character.
     - parameter unityType: The unity used to measure a sport's performance.
     - parameter pointsConversion: The needed performance's value to get one point, or the earned points each time this sport has been made.
     */
    mutating func modify(_ sport: Sport, name: String?, icon: String?, unityType: Sport.UnityType?, pointsConversion: [String?]) {
        guard let name = name, let icon = icon, let unityType = unityType else { return }
        error = sportsManager.modify(sport, name: name, icon: icon, unityType: unityType, pointsConversion: pointsConversion)
        refresh()
    }
    /**
     Delete sport.
     - parameter sport: The sport to delete.
     */
    mutating func delete(_ sport: Sport) {
        error = sportsManager.delete(sport)
        refresh()
    }
}

// MARK: - Performances

extension Game {
    
    /**
     Add a performance.
     - parameter sport: The sport in which the performance has been made.
     - parameter athletics: Athletics who did the performance.
     - parameter value: The performance's value.
     - parameter addToCommonPot: A boolean which indicates whether the points have to be added to the common pot, or the athletics pots.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     */
    mutating func addPerformance(sport: Sport, athletics: [Athletic], value: [String?], addToCommonPot: Bool) {
        error = performancesManager.add(sport: sport, athletics: athletics, value: value, addToCommonPot: addToCommonPot, moneyConversion: settings.moneyConversion, date: Date().now, predictionDate: settings.predictionDate)
        refresh()
    }
    /**
     Delete a performance.
     - parameter performance: The performance to delete.
     - parameter athletic: If the performance has to be deleted for a single athletic, set the athletic for whom the performance has to be deleted; otherwise, to delete the performance for all athletics, set *nil*.
     */
    mutating func delete(_ performance: Performance, of athletic: Athletic?) {
        if let athletic = athletic {
            error = performancesManager.delete(performance, of: athletic, moneyConversion: settings.moneyConversion, predictionDate: settings.predictionDate)
        } else {
            error = performancesManager.delete(performance, moneyConversion: settings.moneyConversion, predictionDate: settings.predictionDate)
        }
        refresh()
    }

}

// MARK: - Change money

extension Game {
    /**
     Add money to a pot.
     - parameter athletic: The pot's owner, set *nil* to modify the common pot.
     - parameter amount: The amount to add.
     */
    mutating func addMoney(for athletic: Athletic? = nil, amount: String) {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        guard let amount = formatter.number(from: amount) as? Double else { return }
        error = potsManager.addMoney(for: athletic, amount: amount, with: settings.moneyConversion, predictionDate: settings.predictionDate)
        refresh()
    }
    /**
     Withdraw money from a pot.
     - parameter athletic: The pot's owner, set *nil* to modify the common pot.
     - parameter amount: The amount or withdraw.
     */
    mutating func withdrawMoney(for athletic: Athletic? = nil, amount: String) {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        guard let amount = formatter.number(from: amount) as? Double else { return }
        error = potsManager.withdrawMoney(for: athletic, amount: amount, with: settings.moneyConversion, predictionDate: settings.predictionDate)
        refresh()
    }
}

// MARK: - Get error

extension Game {
    /**
     Get the error in the *error* property, and then set *nil* instead.
     */
    mutating func getError() -> ApplicationErrors? {
        let error = self.error
        self.error = nil
        return error
    }
}


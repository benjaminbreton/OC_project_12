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
    let athleticsManager: AthleticsManager
    let sportsManager: SportsManager
    let performancesManager: PerformancesManager
    let potsManager: PotsManager
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
    
    /// Update athletics array.
    mutating func refresh() {
        guard error == nil else { return }
        athletics = coreDataStack.entities.allAthletics
        performances = coreDataStack.entities.allPerformances
        sports = coreDataStack.entities.allSports
        potsManager.getEvolution()
        coreDataStack.saveContext()
    }
    
}

// MARK: - Athletics

extension Game {
    
    mutating func addAthletic(name: String?, image: Data?) {
        guard let name = name else { return }
        let pot = potsManager.create()
        error = athleticsManager.add(name: name, image: image, pot: pot)
        refresh()
    }
    mutating func modify(_ athletic: Athletic, name: String?, image: Data?){
        guard let name = name else { return }
        error = athleticsManager.modify(athletic, name: name, image: image)
        refresh()
    }
    mutating func delete(_ athletic: Athletic) {
        athletic.willBeDeleted = true
        coreDataStack.saveContext()
        refresh()
        error = athleticsManager.delete(athletic)
        refresh()
    }
}

// MARK: - Settings

extension Game {
    mutating func updateSettings(predictedAmountDate: Date, pointsForOneEuro: String?) {
        guard let points = pointsForOneEuro, points.count < 5, let intPoints = Int(points) else { return }
        settings.predictedAmountDate = predictedAmountDate
        settings.pointsForOneEuro = intPoints
    }
}

// MARK: - Sports

extension Game {
    mutating func addSport(name: String?, icon: String?, unityType: Int16?, valueForOnePoint: [String?]) {
        error = sportsManager.add(name: name, icon: icon, unityType: unityType, valueForOnePoint: valueForOnePoint)
        refresh()
    }
    
    mutating func modify(_ sport: Sport, name: String?, icon: String?, unityType: Int16?, valueForOnePoint: [String?]) {
        guard let name = name else { return }
        error = sportsManager.modify(sport, name: name, icon: icon, unityType: unityType, valueForOnePoint: valueForOnePoint)
        refresh()
    }
    
    mutating func delete(_ sport: Sport) {
        error = sportsManager.delete(sport)
        refresh()
    }
}

// MARK: - Performances

extension Game {
    
    mutating func addPerformance(sport: Sport, athletics: [Athletic], value: [String?], addToCommonPot: Bool) {
        error = performancesManager.add(sport: sport, athletics: athletics, value: value, addToCommonPot: addToCommonPot, pointsForOneEuro: settings.pointsForOneEuro)
        refresh()
    }
    
    mutating func delete(_ performance: Performance) {
        error = performancesManager.delete(performance, pointsForOneEuro: settings.pointsForOneEuro)
        refresh()
    }
    mutating func deletePerformances<T: NSManagedObject>(of item: T) {
        error = performancesManager.delete(of: item, pointsForOneEuro: settings.pointsForOneEuro)
        refresh()
    }

}

// MARK: - Change money

extension Game {
    mutating func addMoney(for athletic: Athletic? = nil, amount: String) {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        guard let amount = formatter.number(from: amount) as? Double else { return }
        error = potsManager.addMoney(for: athletic, amount: amount, with: settings.pointsForOneEuro)
        refresh()
    }
    mutating func withdrawMoney(for athletic: Athletic? = nil, amount: String) {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        guard let amount = formatter.number(from: amount) as? Double else { return }
        error = potsManager.withdrawMoney(for: athletic, amount: amount, with: settings.pointsForOneEuro)
        refresh()
    }
}

// MARK: - Get error

extension Game {
    mutating func getError() -> ApplicationErrors? {
        let error = self.error
        self.error = nil
        return error
    }
}


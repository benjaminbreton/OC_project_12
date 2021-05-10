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
    private(set) var error: ApplicationErrors?
    /// All points added to the common pot.
    var allCommonPoints: Double
    /// Last asked statistics.
    var askedStatistics: Pot.Statistics?
    let athleticsManager: AthleticsManager
    let sportsManager: SportsManager
    let performancesManager: PerformancesManager
}

// MARK: - Init

extension Game {
    /// Create game with the entered Coredatastack.
    /// - parameter coreDataStack: Coredatastack used to save and load datas from CoreData (Coredatastack() by default).
    init(coreDataStack: CoreDataStack = CoreDataStack()) {
        self.settings = Settings()
        self.coreDataStack = coreDataStack
        athletics = []
        sports = []
        performances = []
        allCommonPoints = 0
        athleticsManager = AthleticsManager(coreDataStack)
        sportsManager = SportsManager(coreDataStack)
        performancesManager = PerformancesManager(coreDataStack)
        commonPot = getCommonPot()
        if settings.gameAlreadyExists {
            athletics = coreDataStack.entities.allAthletics
            sports = coreDataStack.entities.allSports
            performances = coreDataStack.entities.allPerformances
            allCommonPoints = getAllCommonPoints()
            athleticsManager.getEvolution()
        }
        settings.gameAlreadyExists = true
        self.coreDataStack.saveContext()
        
    }
    
    mutating func addAthletic(name: String?, image: Data?) {
        guard let name = name else { return }
        let pot = getNewPot()
        error = athleticsManager.add(name: name, image: image, pot: pot)
        updateProperties()
    }
    mutating func modify(_ athletic: Athletic, name: String?, image: Data?){
        guard let name = name else { return }
        error = athleticsManager.modify(athletic, name: name, image: image)
        updateProperties()
    }
    mutating func delete(_ athletic: Athletic) {
        athletic.willBeDeleted = true
        coreDataStack.saveContext()
        updateProperties()
        error = athleticsManager.delete(athletic)
        updateProperties()
    }
    mutating func updateSettings(predictedAmountDate: Date, pointsForOneEuro: String?) {
        guard let points = pointsForOneEuro, points.count < 5, let intPoints = Int(points) else { return }
        settings.predictedAmountDate = predictedAmountDate
        settings.pointsForOneEuro = intPoints
    }
    
    mutating func addSport(name: String?, icon: String?, unityType: Int16?, valueForOnePoint: [String?]) {
        error = sportsManager.add(name: name, icon: icon, unityType: unityType, valueForOnePoint: valueForOnePoint)
        updateProperties()
    }
    
    mutating func modify(_ sport: Sport, name: String?, icon: String?, unityType: Int16?, valueForOnePoint: [String?]) {
        guard let name = name else { return }
        error = sportsManager.modify(sport, name: name, icon: icon, unityType: unityType, valueForOnePoint: valueForOnePoint)
        updateProperties()
    }
    
    mutating func delete(_ sport: Sport) {
        error = sportsManager.delete(sport)
        updateProperties()
    }
    
    mutating func addPerformance(sport: Sport, athletics: [Athletic], value: [String?], addToCommonPot: Bool) {
        error = performancesManager.add(sport: sport, athletics: athletics, value: value, addToCommonPot: addToCommonPot)
        updateProperties()
    }
    
    mutating func delete(_ performance: Performance) {
        error = performancesManager.delete(performance)
        updateProperties()
    }
    mutating func deletePerformances<T: NSManagedObject>(of item: T) {
        error = performancesManager.delete(of: item)
        updateProperties()
    }

}



// MARK: - Supporting methods
    
extension Game {
    /// Convert a set in an array.
    /// - parameter set: The set to be converted.
    /// - returns: The array based on the set.
    private func getArrayFromSet<T: NSManagedObject>(_ set: NSSet?) -> [T] {
        guard let arraySet = set, let array = arraySet.allObjects as? [T] else { return [] }
        return array
    }
    /// Get a pot from its owner.
    /// - parameter athletic: Pot's owner (nil to get the common pot).
    /// - returns: Asked pot.
    private func getPot(of athletic: Athletic? = nil) -> Pot {
        if let athletic = athletic, let pot = athletic.pot {
            return pot
        } else {
            guard let commonPot = commonPot else { return getNewPot() }
            return commonPot
        }
    }
    /// Create a new pot for its future owner.
    /// - parameter athletic: Future pot's owner (nil to create the common pot).
    /// - returns: The new pot.
    @discardableResult
    private func getNewPot(for athletic: Athletic? = nil) -> Pot {
        let pot = Pot(context: coreDataStack.viewContext)
        pot.amount = 0
        pot.owner = athletic
        pot.creationDate = Date()
        pot.evolutionType = Pot.EvolutionType.same.int16
        pot.lastEvolution = 0
        pot.lastEvolutionDate = Date()
        pot.points = 0
        coreDataStack.saveContext()
        return pot
    }
    
    private func getCommonPot() -> Pot {
        let request: NSFetchRequest<Pot> = Pot.fetchRequest()
        let predicate = NSPredicate(format: "owner == nil")
        request.predicate = predicate
        guard let pots = try? coreDataStack.viewContext.fetch(request), pots.count > 0 else { return getNewPot() }
        return pots[0]
    }
    private func getAllCommonPoints() -> Double {
        if performances.count > 0 {
            return Double(performances.map({ $0.addedToCommonPot ? $0.potAddings : 0 }).reduce(0, +))
        } else {
            return 0
        }
    }
    /// Update athletics array.
    mutating private func updateProperties() {
        athletics = coreDataStack.entities.allAthletics
        performances = coreDataStack.entities.allPerformances
        sports = coreDataStack.entities.allSports
        coreDataStack.saveContext()
    }
}




// MARK: - Performances

extension Game {
    
    
}

// MARK: - Statistics

extension Game {
    /// Get athletic's or common pot's statistics.
    /// - parameter athletic: The athletic for whom statistics have to be getted (nil to get common pot's statistics).
    mutating func getStatistics(for athletic: Athletic? = nil) {
        let pot = getPot(of: athletic)
        pot.getStatistics(allCommonPoints: allCommonPoints, predictedAmountDate: settings.predictedAmountDate) { statistics in
            self.askedStatistics = statistics
            self.settings.predictedAmountDate = statistics.predictedAmountDate
            self.coreDataStack.saveContext()
        }
    }
}

// MARK: - Change money

extension Game {
    /// Add money to a pot.
    /// - parameter athletic: The athletic for whom money has to be added (nil to add to the common pot).
    /// - parameter amount: Amount to add.
    mutating func addMoney(for athletic: Athletic? = nil, amount: Double) {
        let pot = getPot(of: athletic)
        pot.amount += amount
        if let athletic = athletic {
            athletic.pot = pot
        } else {
            commonPot = pot
        }
        coreDataStack.saveContext()
    }
    /// Withdraw money to a pot.
    /// - parameter athletic: The athletic for whom money has to be withdrawn (nil to withdraw to the common pot).
    /// - parameter amount: Amount to withdraw.
    mutating func withdrawMoney(for athletic: Athletic? = nil, amount: Double) {
        let pot = getPot(of: athletic)
        pot.amount -= amount
        if let athletic = athletic {
            athletic.pot = pot
        } else {
            commonPot = pot
        }
        coreDataStack.saveContext()
    }
}

extension Game {
    mutating func getError() -> ApplicationErrors? {
        let error = self.error
        self.error = nil
        return error
    }
}


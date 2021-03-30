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
    private(set) var settings = Settings()
    /// Coredatastack used to save and load datas from CoreData.
    private let coreDataStack: CoreDataStack
    /// All  registered athletics.
    var athletics: [Athletic] {
        let request: NSFetchRequest<Athletic> = Athletic.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let result = try? coreDataStack.viewContext.fetch(request) else { return [] }
        return result
    }
    /// All registered sports.
    var sports: [Sport] {
        let request: NSFetchRequest<Sport> = Sport.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let result = try? coreDataStack.viewContext.fetch(request) else { return [] }
        return result
    }
    /// All registered performances.
    var performances: [Performance] {
        let request: NSFetchRequest<Performance> = Performance.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        guard let result = try? coreDataStack.viewContext.fetch(request) else { return [] }
        return result
    }
    /// Pot used as common pot.
    var commonPot: Pot {
        let request: NSFetchRequest<Pot> = Pot.fetchRequest()
        let predicate = NSPredicate(format: "owner == nil")
        request.predicate = predicate
        guard let pots = try? coreDataStack.viewContext.fetch(request) else { return getNewPot() }
        return pots[0]
    }
    /// All points added to the common pot.
    var allCommonPoints: Double {
        if performances.count > 0 {
            return performances.map({ $0.addedToCommonPot ? $0.potAddings : 0 }).reduce(0, +)
        } else {
            return 0
        }
    }
    /// Last asked statistics.
    var askedStatistics: Pot.Statistics?
}

// MARK: - Init

extension Game {
    /// Create game with the entered Coredatastack.
    /// - parameter coreDataStack: Coredatastack used to save and load datas from CoreData (Coredatastack() by default).
    init(coreDataStack: CoreDataStack = CoreDataStack()) {
        self.coreDataStack = coreDataStack
        if !settings.gameAlreadyExists {
            let _ = getNewPot()
        }
    }
}

// MARK: - Athletics

extension Game {
    
    // MARK: - Add
    
    /// Add athletic to the game.
    /// - parameter name: Athletic's name to add.
    /// - parameter completionHandler: Code to execute when athletic has been added.
    func addAthletic(_ name: String, completionHandler: (Result<[Athletic], ApplicationErrors>) -> Void) {
        if athleticExists(name) {
            completionHandler(.failure(.existingAthletic))
            return
        }
        addNewAthletic(name)
        coreDataStack.saveContext()
        completionHandler(.success(athletics))
    }
    /// Check if an athletic exists in athletics.
    /// - parameter name: Athletic's name to check.
    /// - returns: A boolean which indicates whether the athletic exists or not.
    private func athleticExists(_ name: String) -> Bool {
        for existingAthletic in athletics {
            if existingAthletic.name == name {
                return true
            }
        }
        return false
    }
    /// Create an athletic.
    /// - parameter name: Athletic's name to create.
    private func addNewAthletic(_ name: String) {
        let athletic = Athletic(context: coreDataStack.viewContext)
        athletic.name = name
        let pot = getNewPot(for: athletic)
        athletic.pot = pot
    }
    
    // MARK: - Delete
    
    /// Delete an athletic
    /// - parameter athletic: Athletic to delete.
    /// - parameter completionHandler: Code to execute when athletic has been deleted.
    func deleteAthletic(_ athletic: Athletic, completionHandler: (Result<[Athletic], ApplicationErrors>) -> Void) {
        deleteAthleticPerformances(athletic)
        coreDataStack.viewContext.delete(athletic)
        coreDataStack.saveContext()
        completionHandler(.success(self.athletics))
    }
    /// Delete performances in which the only athletic is an athletic to delete, without cancelling earned points.
    /// - parameter athletic: The athletic to be deleted.
    private func deleteAthleticPerformances(_ athletic: Athletic) {
        let performances: [Performance] = getArrayFromSet(athletic.performances)
        for performance in performances {
            let athletics: [Athletic] = getArrayFromSet(performance.athletics)
            if athletics.count == 1 && athletics[0] == athletic {
                performPerformanceDeletion(performance, cancelPoints: false)
            }
        }
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
            return commonPot
        }
    }
    /// Create a new pot for its future owner.
    /// - parameter athletic: Future pot's owner (nil to create the common pot).
    /// - returns: The new pot.
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
}

// MARK: - Introduction's methods

extension Game {
    /// Toggle didSeeIntroduction property.
    mutating func introductionHasBeenSeen() {
        settings.didSeeIntroduction = true
    }
}

// MARK: - Sports

extension Game {
    
    // MARK: - Add
    
    /// Add sport to the game.
    /// - parameter name: Sport's name to create.
    /// - parameter unityType: Sport's unity type.
    /// - parameter valueForOnePoint: Unity type's value to get one point.
    /// - parameter completionHandler: Code to execute when sport has been added.
    func addSport(_ name: String, unityType: Sport.UnityType, valueForOnePoint: Double, completionHandler: (Result<[Sport], ApplicationErrors>) -> Void) {
        if sportExists(name) {
            completionHandler(.failure(.existingSport))
            return
        }
        addNewSport(name, unityType: unityType, valueForOnePoint: valueForOnePoint)
        coreDataStack.saveContext()
        completionHandler(.success(sports))
    }
    /// Check if a sport exists in sports.
    /// - parameter name: Sport's name to check.
    /// - returns: A boolean which indicates whether the sport exists or not.
    private func sportExists(_ name: String) -> Bool {
        for existingSport in sports {
            if existingSport.name == name {
                return true
            }
        }
        return false
    }
    /// Create a sport.
    /// - parameter name: Sport's name to create.
    /// - parameter unityType: Sport's unity type.
    /// - parameter valueForOnePoint: Unity type's value to get one point.
    /// - parameter coreDataStack: Stack to use to create the athletic.
    private func addNewSport(_ name: String, unityType: Sport.UnityType, valueForOnePoint: Double) {
        let sport = Sport(context: coreDataStack.viewContext)
        sport.name = name
        sport.unityInt16 = unityType.int16
        sport.valueForOnePoint = valueForOnePoint
    }
    
    // MARK: - Delete
    
    /// Delete a sport.
    /// - parameter sport: Sport to delete.
    /// - parameter completionHandler: Code to execute when athletic has been deleted.
    func deleteSport(_ sport: Sport, completionHandler: (Result<[Sport], ApplicationErrors>) -> Void) {
        coreDataStack.viewContext.delete(sport)
        coreDataStack.saveContext()
        completionHandler(.success(self.sports))
    }
}

// MARK: - Performances

extension Game {
    
    // MARK: - Add
    
    /// Add performance.
    /// - parameter sport: Performance's sport.
    /// - parameter athletics: Athletics who made the performance.
    /// - parameter value: Performance's value, depending on sport's unit type.
    /// - parameter addToCommonPot: Boolean which indicates whether the points have to be added to the common pot or not.
    /// - parameter completionHandler: Actions to do once performance has been added.
    func addPerformance(sport: Sport, athletics: [Athletic], value: [Double], addToCommonPot: Bool, completionHandler: (Result<[Performance], ApplicationErrors>) -> Void) {
        guard athletics.count > 0 else {
            completionHandler(.failure(.performanceWithoutAthletic))
            return
        }
        let performance = getNewPerformance(sport: sport, athletics: athletics, value: value, addToCommonPot: addToCommonPot)
        addPointsToPot(with: performance)
        coreDataStack.saveContext()
        completionHandler(.success(performances))
    }
    /// Get new performance with choosen parameters.
    /// - parameter sport: Performance's sport.
    /// - parameter athletics: Athletics who made the performance.
    /// - parameter value: Performance's value, depending on sport's unit type.
    /// - parameter coreDataStack: Coredatastack in which the performance has to be made.
    /// - returns: The created performance.
    private func getNewPerformance(sport: Sport, athletics: [Athletic], value: [Double], addToCommonPot: Bool) -> Performance {
        let performance = Performance(context: coreDataStack.viewContext)
        performance.sport = sport
        performance.athletics = NSSet(array: athletics)
        performance.value = sport.unityType.value(for: value)
        performance.addedToCommonPot = addToCommonPot
        performance.date = Date()
        performance.potAddings = sport.pointsToAdd(value: performance.value)
        performance.initialAthleticsCount = Double(athletics.count)
        return performance
    }
    /// Add points earned with a performance to pot depending on performance's parameters.
    /// - parameter performance: Performance with which points have been earned.
    private func addPointsToPot(with performance: Performance) {
        let athletics: [Athletic] = getArrayFromSet(performance.athletics)
        if performance.addedToCommonPot {
            commonPot.addPoints(performance.potAddings * performance.initialAthleticsCount)
        } else {
            for athletic in athletics {
                guard let pot = athletic.pot else { return }
                pot.addPoints(performance.potAddings)
            }
        }
    }
    
    // MARK: - Delete
    
    /// Delete performance.
    /// - parameter performance: Performance to delete.
    func deletePerformance(_ performance: Performance) {
        performPerformanceDeletion(performance, cancelPoints: true)
    }
    /// Delete performance.
    /// - parameter performance: Performance to delete.
    /// - parameter cancelPoints: Boolean which indicates whether the points earned by the performance have to be cancelled or not.
    private func performPerformanceDeletion(_ performance: Performance, cancelPoints: Bool) {
        if cancelPoints { cancelPotAddings(performance) }
        coreDataStack.viewContext.delete(performance)
        coreDataStack.saveContext()
    }
    /// Cancel points added in pots by a performance.
    /// - parameter performance: Performance which added points.
    private func cancelPotAddings(_ performance: Performance) {
        let athletics: [Athletic] = getArrayFromSet(performance.athletics)
        if performance.addedToCommonPot {
            commonPot.addPoints(-performance.potAddings * performance.initialAthleticsCount)
        } else {
            for athletic in athletics {
                guard let pot = athletic.pot else { return }
                pot.addPoints(-performance.potAddings)
            }
        }
    }
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
    func addMoney(for athletic: Athletic? = nil, amount: Double) {
        let pot = getPot(of: athletic)
        pot.amount += amount
        coreDataStack.saveContext()
    }
    /// Withdraw money to a pot.
    /// - parameter athletic: The athletic for whom money has to be withdrawn (nil to withdraw to the common pot).
    /// - parameter amount: Amount to withdraw.
    func withdrawMoney(for athletic: Athletic? = nil, amount: Double) {
        let pot = getPot(of: athletic)
        pot.amount -= amount
        coreDataStack.saveContext()
    }
}

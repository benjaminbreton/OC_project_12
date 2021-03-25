//
//  Game.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/03/2021.
//

import Foundation
import CoreData

// MARK: - Game properties

public class Game: NSManagedObject {
    
    // MARK: - Properties
    
    /// Stack used to get and set datas in CoreData.
    var coreDataStack: CoreDataStack?
    
    var athletics: [Athletic] {
        let request: NSFetchRequest<Athletic> = Athletic.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let coreDataStack = coreDataStack, let result = try? coreDataStack.viewContext.fetch(request) else { return [] }
        return result
    }
    
    var sports: [Sport] {
        let request: NSFetchRequest<Sport> = Sport.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let coreDataStack = coreDataStack, let result = try? coreDataStack.viewContext.fetch(request) else { return [] }
        return result
    }
    
    var performances: [Performance] {
        let request: NSFetchRequest<Performance> = Performance.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        guard let coreDataStack = coreDataStack, let result = try? coreDataStack.viewContext.fetch(request) else { return [] }
        return result
    }
    
    var allCommonPoints: Double {
        if performances.count > 0 {
            return performances.map({ $0.addedToCommonPot ? $0.potAddings : 0 }).reduce(0, +)
        } else {
            return 0
        }
    }
}

// MARK: - Static methods

extension Game {

    // MARK: - Init game
    
    /// Create a Game instance with saved datas.
    /// - parameter coreDataStack: Stack used to get and set datas in CoreData.
    /// - returns: A Game instance.
    static func initGame(coreDataStack: CoreDataStack) -> Game {
        let request: NSFetchRequest<Game> = Game.fetchRequest()
        guard let result = try? coreDataStack.viewContext.fetch(request), result.count > 0 else {
            return getNewGame(coreDataStack: coreDataStack)
        }
        result[0].coreDataStack = coreDataStack
        return result[0]
    }
    /// Create a Game instance if no datas have been saved in CoreData.
    /// - parameter coreDataStack: Stack used to get and set datas in CoreData.
    /// - returns: A Game instance.
    static private func getNewGame(coreDataStack: CoreDataStack) -> Game {
        let commonPot = Pot(context: coreDataStack.viewContext)
        let game = Game(context: coreDataStack.viewContext)
        commonPot.game = game
        commonPot.creationDate = Date()
        commonPot.lastEvolution = 0
        commonPot.lastEvolutionDate = Date()
        commonPot.evolutionType = 0
        game.didSeeIntroduction = false
        game.commonPot = commonPot
        game.pointsForOneEuro = 1000
        game.coreDataStack = coreDataStack
        game.predictedAmountDate = Date() + 30*24*3600
        coreDataStack.saveContext()
        return game
    }
}

// MARK: - Athletics

extension Game {
    
    // MARK: - Add
    
    /// Add athletic to the game.
    /// - parameter name: Athletic's name to add.
    /// - parameter completionHandler: Code to execute when athletic has been added.
    func addAthletic(_ name: String, completionHandler: (Result<[Athletic], ApplicationErrors>) -> Void) {
        guard let coreDataStack = coreDataStack else { return }
        if athleticExists(name) {
            completionHandler(.failure(.existingAthletic))
            return
        }
        addNewAthletic(name, coreDataStack: coreDataStack)
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
    /// - parameter coreDataStack: Stack to use to create the athletic.
    private func addNewAthletic(_ name: String, coreDataStack: CoreDataStack) {
        let athletic = Athletic(context: coreDataStack.viewContext)
        athletic.name = name
        let pot = Pot(context: coreDataStack.viewContext)
        pot.game = self
        pot.creationDate = Date()
        pot.lastEvolution = 0
        pot.lastEvolutionDate = Date()
        pot.evolutionType = 0
        athletic.pot = pot
    }
    
    // MARK: - Delete
    
    /// Delete an athletic
    /// - parameter athletic: Athletic to delete.
    /// - parameter completionHandler: Code to execute when athletic has been deleted.
    func deleteAthletic(_ athletic: Athletic, completionHandler: (Result<[Athletic], ApplicationErrors>) -> Void) {
        guard let coreDataStack = coreDataStack else { return }
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
    
    /// Create a predicate to get a coredata's entity from its name.
    /// - parameter name: Entity's name to search.
    /// - parameter coreDataStack : Coredatastack to use to search entity.
    /// - returns: An array with all existing entities founded.
//    private func getEntityWithItsName<Type>(_ name: String, coreDataStack: CoreDataStack) -> [Type]? where Type: NSManagedObject {
//        let request: NSFetchRequest<NSFetchRequestResult> = Type.fetchRequest()
//        request.predicate = NSPredicate(format: "name == %@", name)
//        let result = try? coreDataStack.viewContext.fetch(request) as? [Type]
//        return result
//    }
    /// Convert a set in an array.
    /// - parameter set: The set to be converted.
    /// - returns: The array based on the set.
    private func getArrayFromSet<T: NSManagedObject>(_ set: NSSet?) -> [T] {
        guard let arraySet = set, let array = arraySet.allObjects as? [T] else { return [] }
        return array
    }
}

// MARK: - Introduction's methods

extension Game {
    
    /// Toggle didSeeIntroduction property.
    func introductionHasBeenSeen() {
        guard let coreDataStack = coreDataStack else { return }
        didSeeIntroduction = true
        coreDataStack.saveContext()
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
        guard let coreDataStack = coreDataStack else { return }
        if sportExists(name) {
            completionHandler(.failure(.existingSport))
            return
        }
        addNewSport(name, unityType: unityType, valueForOnePoint: valueForOnePoint, coreDataStack: coreDataStack)
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
    private func addNewSport(_ name: String, unityType: Sport.UnityType, valueForOnePoint: Double, coreDataStack: CoreDataStack) {
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
        guard let coreDataStack = coreDataStack else { return }
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
        guard let coreDataStack = coreDataStack else { return }
        guard athletics.count > 0 else {
            completionHandler(.failure(.performanceWithoutAthletic))
            return
        }
        let performance = getNewPerformance(sport: sport, athletics: athletics, value: value, coreDataStack: coreDataStack, addToCommonPot: addToCommonPot)
        addPointsToPot(with: performance)
        coreDataStack.saveContext()
        completionHandler(.success(performances))
        return
    }
    /// Get new performance with choosen parameters.
    /// - parameter sport: Performance's sport.
    /// - parameter athletics: Athletics who made the performance.
    /// - parameter value: Performance's value, depending on sport's unit type.
    /// - parameter coreDataStack: Coredatastack in which the performance has to be made.
    /// - returns: The created performance.
    private func getNewPerformance(sport: Sport, athletics: [Athletic], value: [Double], coreDataStack: CoreDataStack, addToCommonPot: Bool) -> Performance {
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
            guard let pot = commonPot else { return }
            pot.addPoints(performance.potAddings * performance.initialAthleticsCount)
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
        guard let coreDataStack = coreDataStack else { return }
        if cancelPoints { cancelPotAddings(performance) }
        coreDataStack.viewContext.delete(performance)
        coreDataStack.saveContext()
    }
    /// Cancel points added in pots by a performance.
    /// - parameter performance: Performance which added points.
    private func cancelPotAddings(_ performance: Performance) {
        let athletics: [Athletic] = getArrayFromSet(performance.athletics)
        if performance.addedToCommonPot {
            guard let pot = commonPot else { return }
            pot.addPoints(-performance.potAddings * performance.initialAthleticsCount)
        } else {
            for athletic in athletics {
                guard let pot = athletic.pot else { return }
                pot.addPoints(-performance.potAddings)
            }
        }
    }
}

// MARK: - Pot

extension Game {
    
    
    // MARK: - Add money
    
    /// Add money directly to a pot.
    /// - parameter owner: The pot's owner.
    /// - parameter amount: Amount to add to the pot.
    func addMoney<T: NSManagedObject>(to owner: T, amount: Double) {
        if amount > 0 {
            changeMoney(to: owner, amount: amount)
        }
    }
    
    // MARK: - Withdraw money
    
    /// Withdraw money directly to a pot.
    /// - parameter owner: The pot's owner.
    /// - parameter amount: Amount to withdraw to the pot.
    func withdrawMoney<T: NSManagedObject>(to owner: T, amount: Double) {
        if amount > 0 {
            changeMoney(to: owner, amount: -amount)
        }
    }
    
    // MARK: - Supporting method
    
    /// Change amount of a pot.
    /// - parameter owner: The pot's owner.
    /// - parameter amount: Changement to do.
    private func changeMoney<T: NSManagedObject>(to owner: T, amount: Double) {
        if let owner = owner as? Game {
            guard let pot = owner.commonPot, let coreDataStack = coreDataStack else { return }
            pot.amount += amount
            coreDataStack.saveContext()
        }
        if let owner = owner as? Athletic {
            guard let pot = owner.pot, let coreDataStack = coreDataStack else { return }
            pot.amount += amount
            coreDataStack.saveContext()
        }
    }
}

// MARK: - Get statistics

extension Game {
    
    // MARK: - Stats typealias
    
    typealias PotInformations = (pot: Pot, creationDate: Date, lastEvolutionDate: Date)
    typealias EvolutionInformations = (evolution: Double, evolutionType: Pot.EvolutionType, evolutionDate: Date)
    typealias Statistics = (amount: String, predictedAmount: String, evolution: Pot.EvolutionType)
    
    // MARK: - Get stats
    
    /// Get athletic's or commonpot's statistics.
    /// - parameter athletic: Athletic for whom statistics have to be getted, default value : nil to get commonpot's statistics.
    /// - parameter completionHandler: Actions to do with the returned stats.
    func getStatistics(for athletic: Athletic? = nil, completionHandler: (Statistics) -> Void) {
        // get pot informations
        guard let potInformations = getPotInformations(for: athletic) else { return }
        let pot = potInformations.pot
        let creationDate = potInformations.creationDate
        // get evolution
        let evolutionInformations = getEvolutionInformations(athletic: athletic, potInformations: potInformations)
        let evolution: Double = evolutionInformations.evolution
        let evolutionType: Pot.EvolutionType = evolutionInformations.evolutionType
        let evolutionDate: Date = evolutionInformations.evolutionDate
        // format amounts
        let formatter = getAmountFormatter()
        guard let nextAmount = getPredictedAmount(from: evolutionDate, with: evolution, pot: pot),
              let amount: String = formatter.string(from: NSNumber(value: pot.amount)),
              let predictedAmount: String = formatter.string(from: NSNumber(value: nextAmount)) else { return }
        // return stats
        if creationDate + 24 * 3600 > Date() {
            completionHandler((amount: amount, predictedAmount: "No prediction can't be done for the first 24 hours.", evolution: .same))
            return
        }
        completionHandler((amount: amount, predictedAmount: predictedAmount, evolution: evolutionType))
    }
    private func getPotInformations(for athletic: Athletic?) -> PotInformations? {
        if let athletic = athletic {
            guard let pot = athletic.pot, let creationDate = pot.creationDate, let lastEvolutionDate = pot.lastEvolutionDate else { return nil }
            return (pot: pot, creationDate: creationDate, lastEvolutionDate: lastEvolutionDate)
        } else {
            guard let pot = commonPot, let creationDate = pot.creationDate, let lastEvolutionDate = pot.lastEvolutionDate else { return nil }
            return (pot: pot, creationDate: creationDate, lastEvolutionDate: lastEvolutionDate)
        }
    }
    private func getEvolutionInformations(athletic: Athletic?, potInformations: PotInformations) -> EvolutionInformations {
        let pot = potInformations.pot
        let creationDate = potInformations.creationDate
        let lastEvolutionDate = potInformations.lastEvolutionDate
        if lastEvolutionDate + 24 * 3600 > Date() {
            // evolution doesn't have to be updated
            return (evolution: pot.lastEvolution, evolutionType: pot.evolutionType.potEvolutionType, evolutionDate: lastEvolutionDate)
        } else {
            // update evolution
            let evolutionDate = Date()
            let allPoints: Double
            if let athletic = athletic {
                allPoints = athletic.allPoints
            } else {
                allPoints = allCommonPoints
            }
            let duration = DateInterval(start: creationDate, end: evolutionDate).duration
            let evolution = duration/allPoints
            let evolutionType = Pot.EvolutionType.determinate(from: pot.lastEvolution, to: evolution)
            pot.lastEvolution = evolution
            pot.lastEvolutionDate = evolutionDate
            pot.evolutionType = evolutionType.int16
            return (evolution: evolution, evolutionType: evolutionType, evolutionDate: evolutionDate)
        }
    }
    private func getPredictedAmount(from evolutionDate: Date, with evolution: Double, pot: Pot) -> Double? {
        guard var nextDate = predictedAmountDate else { return nil }
        if nextDate <= Date() {
            nextDate = Date() + 30*24*3600
            predictedAmountDate = nextDate
        }
        let nextStep = DateInterval(start: evolutionDate, end: nextDate).duration
        let amountToAdd = nextStep * evolution
        let nextAmount = pot.amount + amountToAdd
        return nextAmount
    }
    private func getAmountFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = Locale.current
        return formatter
    }
    
}








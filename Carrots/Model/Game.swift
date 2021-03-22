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
        return result[0]
    }
    /// Create a Game instance if no datas have been saved in CoreData.
    /// - parameter coreDataStack: Stack used to get and set datas in CoreData.
    /// - returns: A Game instance.
    static private func getNewGame(coreDataStack: CoreDataStack) -> Game {
        let commonPot = Pot(context: coreDataStack.viewContext)
        let game = Game(context: coreDataStack.viewContext)
        game.didSeeIntroduction = false
        game.commonPot = commonPot
        game.pointsForOneEuro = 1000
        game.coreDataStack = coreDataStack
        game.addToCommonPot = true
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
        athletic.pot = pot
    }
    
    // MARK: - Delete
    
    /// Delete an athletic
    /// - parameter athletic: Athletic to delete.
    /// - parameter completionHandler: Code to execute when athletic has been deleted.
    func deleteAthletic(_ athletic: Athletic, completionHandler: (Result<[Athletic], ApplicationErrors>) -> Void) {
        guard let coreDataStack = coreDataStack else { return }
        coreDataStack.viewContext.delete(athletic)
        coreDataStack.saveContext()
        completionHandler(.success(self.athletics))
    }
}

// MARK: - Supporting methods
    
extension Game {
    
    /// Create a predicate to get a coredata's entity from its name.
    /// - parameter name: Entity's name to search.
    /// - parameter coreDataStack : Coredatastack to use to search entity.
    /// - returns: An array with all existing entities founded.
    private func getEntityWithItsName<Type>(_ name: String, coreDataStack: CoreDataStack) -> [Type]? where Type: NSManagedObject {
        let request: NSFetchRequest<NSFetchRequestResult> = Type.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        let result = try? coreDataStack.viewContext.fetch(request) as? [Type]
        return result
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
    func addPerformance(sport: Sport, athletics: [Athletic], value: [Double]) {
        guard let coreDataStack = coreDataStack else { return }
        let performance = getNewPerformance(sport: sport, athletics: athletics, value: value, coreDataStack: coreDataStack)
        addPointsToPot(with: performance)
        coreDataStack.saveContext()
    }
    /// Get new performance with choosen parameters.
    /// - parameter sport: Performance's sport.
    /// - parameter athletics: Athletics who made the performance.
    /// - parameter value: Performance's value, depending on sport's unit type.
    /// - parameter coreDataStack: Coredatastack in which the performance has to be made.
    /// - returns: The created performance.
    private func getNewPerformance(sport: Sport, athletics: [Athletic], value: [Double], coreDataStack: CoreDataStack) -> Performance {
        let performance = Performance(context: coreDataStack.viewContext)
        performance.sport = sport
        performance.athletics = NSSet(array: athletics)
        performance.value = sport.unityType.value(for: value)
        performance.addedToCommonPot = addToCommonPot
        performance.date = Date()
        return performance
    }
    /// Add points earned with a performance to pot depending on performance's parameters.
    /// - parameter performance: Perforamnce with which points have been earned.
    private func addPointsToPot(with performance: Performance) {
        guard let athleticsSet = performance.athletics, let athletics = athleticsSet.allObjects as? [Athletic] else { return }
        if addToCommonPot {
            guard let pot = commonPot else { return }
            pot.points += performance.points
        } else {
            for athletic in athletics {
                guard let pot = athletic.pot else { return }
                pot.points += performance.points
            }
        }
    }
}








//
//  Game.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/03/2021.
//

import Foundation
import CoreData

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
        coreDataStack.saveContext()
        return game
    }
    
    // MARK: - Add athletic
    
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
    
    // MARK: - Delete athletic
    
    /// Delete an athletic
    /// - parameter athletic: Athletic to delete.
    /// - parameter completionHandler: Code to execute when athletic has been deleted.
    func deleteAthletic(_ name: String, completionHandler: (Result<[Athletic], ApplicationErrors>) -> Void) {
        guard let coreDataStack = coreDataStack, let athletics: [Athletic] = getEntityWithItsName(name, coreDataStack: coreDataStack), athletics.count == 1 else { return }
        let athletic = athletics[0]
        coreDataStack.viewContext.delete(athletic)
        coreDataStack.saveContext()
        completionHandler(.success(self.athletics))
    }
    
    // MARK: - Supporting methods
    
    private func getEntityWithItsName<Type>(_ name: String, coreDataStack: CoreDataStack) -> [Type]? where Type: NSManagedObject {
        let request: NSFetchRequest<NSFetchRequestResult> = Type.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        let result = try? coreDataStack.viewContext.fetch(request) as? [Type]
        return result
    }
    
    // MARK: - Introduction
    
    /// Toggle didSeeIntroduction property.
    func introductionHasBeenSeen() {
        guard let coreDataStack = coreDataStack else { return }
        didSeeIntroduction = true
        coreDataStack.saveContext()
    }
    
    // MARK: - Add sport
    
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
    
    // MARK: - Delete sport
    
    /// Delete an athletic
    /// - parameter athletic: Athletic to delete.
    /// - parameter completionHandler: Code to execute when athletic has been deleted.
    func deleteSport(_ name: String, completionHandler: (Result<[Sport], ApplicationErrors>) -> Void) {
        guard let coreDataStack = coreDataStack, let sports: [Sport] = getEntityWithItsName(name, coreDataStack: coreDataStack), sports.count == 1 else { return }
        let sport = sports[0]
        coreDataStack.viewContext.delete(sport)
        coreDataStack.saveContext()
        completionHandler(.success(self.sports))
    }
}







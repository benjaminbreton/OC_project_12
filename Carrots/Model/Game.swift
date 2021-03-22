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
    
    var athleticsArray: [Athletic] {
        guard let athletics = athletics, let existingAthletics: [Athletic] = athletics.allObjects as? [Athletic] else { return [] }
        return existingAthletics
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
    
    // MARK: Add athletic
    
    /// Add athletic to the game.
    /// - parameter name: Athletic's name to add.
    func addAthletic(_ name: String) {
        guard let coreDataStack = coreDataStack else { return }
        if athleticExists(name) { return }
        addNewAthletic(name, coreDataStack: coreDataStack)
        coreDataStack.saveContext()
    }
    /// Check if an athletic exists in athletics.
    /// - parameter name: Athletic's name to check.
    /// - returns: A boolean which indicates whether the athletic exists or not.
    private func athleticExists(_ name: String) -> Bool {
        for existingAthletic in athleticsArray {
            if existingAthletic.name == name {
                return true
            }
        }
        return false
    }
    /// Create an athletic.
    /// - parameter name: Athletic's name to create.
    /// - parameter coreDataStack: Stack to use to create the athletic.
    /// - returns: Created athletic.
    private func addNewAthletic(_ name: String, coreDataStack: CoreDataStack) {
        let athletic = Athletic(context: coreDataStack.viewContext)
        athletic.name = name
        let pot = Pot(context: coreDataStack.viewContext)
        athletic.pot = pot
        athletic.game = self
    }
    
    // MARK: - Introduction
    
    /// Toggle didSeeIntroduction property.
    func introductionHasBeenSeen() {
        guard let coreDataStack = coreDataStack else { return }
        didSeeIntroduction = true
        coreDataStack.saveContext()
    }
}



//
//  AthleticsManager.swift
//  Carrots
//
//  Created by Benjamin Breton on 07/05/2021.
//

import Foundation
import CoreData
// MARK: - Athletics

class AthleticsManager {
    
    let coreDataStack: CoreDataStack
    let evolutionDatasManager: EvolutionDatasManager
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.evolutionDatasManager = EvolutionDatasManager(coreDataStack)
    }

    // MARK: - Add
    
    /// Add athletic to the game.
    /// - parameter name: Athletic's name to add.
    /// - parameter completionHandler: Code to execute when athletic has been added.
    func add(name: String, image: Data?, pot: Pot, today: Date) -> ApplicationErrors? {
        if alreadyExists(name) { return .log(.existingAthletic) }
        create(name: name, image: image, pot: pot, today: today)
        coreDataStack.saveContext()
        return nil
    }
    /// Check if an athletic exists in athletics.
    /// - parameter name: Athletic's name to check.
    /// - returns: A boolean which indicates whether the athletic exists or not.
    private func alreadyExists(_ name: String) -> Bool {
        for existingAthletic in coreDataStack.entities.allAthletics {
            if existingAthletic.name == name {
                return true
            }
        }
        return false
    }
    /// Create an athletic.
    /// - parameter name: Athletic's name to create.
    private func create(name: String, image: Data?, pot: Pot, today: Date) {
        let athletic = Athletic(context: coreDataStack.viewContext)
        athletic.creationDate = today
        athletic.willBeDeleted = false
        athletic.pot = pot
        modify(athletic, name: name, image: image)
        evolutionDatasManager.create(for: athletic, value: 0, date: today)
    }
    
    // MARK: - Modify
    
    @discardableResult
    func modify(_ athletic: Athletic, name: String, image: Data?) -> ApplicationErrors? {
        let existingName = athletic.name == name ? false : alreadyExists(name)
        guard !existingName else { return .log(.existingAthletic) }
        athletic.update(name: name, image: image)
        coreDataStack.saveContext()
        return nil
    }
    
    // MARK: - Delete
    
    /// Delete an athletic
    /// - parameter athletic: Athletic to delete.
    /// - parameter completionHandler: Code to execute when athletic has been deleted.
    func delete(_ athletic: Athletic) -> ApplicationErrors? {
        //deletePerformances(athletic)
        
        //deleteEvolutionDatas(athletic.evolutionDatas)
        coreDataStack.viewContext.delete(athletic)
        coreDataStack.saveContext()
        return nil
    }
    
    // MARK: - Evolution
    
    /**
     Refresh pots amount and their evolution if necessary : every day, athletics can get evolution of their performances during the last 30 days.
     - parameter pointsForOneEuro: Needed number of points to get one euro.
     */
    func refresh() {
        for athletic in coreDataStack.entities.allAthletics {
            if let value = athletic.getEvolution(for: Date().today) {
                print("create athletic evolution")
                evolutionDatasManager.create(for: athletic, value: value, date: Date().today)
                evolutionDatasManager.delete(athletic.evolutionDatasToClean(for: Date().today))
            }
        }
    }
}

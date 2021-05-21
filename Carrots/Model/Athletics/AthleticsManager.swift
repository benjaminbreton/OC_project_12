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
    
    /**
     Add athletic.
     - parameter name: Athletic's name.
     - parameter image: Athletic's image's data.
     - parameter pot: Athletic's pot.
     - parameter creationDate: Athletic's creation date.
     - returns: If an error occurred, the error's type is returned.
     */
    func add(name: String, image: Data?, pot: Pot, creationDate: Date) -> ApplicationErrors? {
        if alreadyExists(name) { return .log(.existingAthletic) }
        create(name: name, image: image, pot: pot, creationDate: creationDate)
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
    /**
     Create athletic.
     - parameter name: Athletic's name.
     - parameter image: Athletic's image's data.
     - parameter pot: Athletic's pot.
     - parameter creationDate: Athletic's creation date.
     */
    private func create(name: String, image: Data?, pot: Pot, creationDate: Date) {
        let athletic = Athletic(context: coreDataStack.viewContext)
        athletic.creationDate = creationDate
        athletic.pot = pot
        modify(athletic, name: name, image: image)
        evolutionDatasManager.create(for: athletic, value: 0, date: creationDate)
    }
    
    // MARK: - Modify
    
    /**
     Modify an athletic.
     - parameter athletic : Athletic to modify.
     - parameter name: Athletic's name.
     - parameter image: Athletic's image's data.
     - returns: If an error occurred, the error's type is returned.
     */
    @discardableResult
    func modify(_ athletic: Athletic, name: String, image: Data?) -> ApplicationErrors? {
        let existingName = athletic.name == name ? false : alreadyExists(name)
        guard !existingName else { return .log(.existingAthletic) }
        athletic.update(name: name, image: image)
        coreDataStack.saveContext()
        return nil
    }
    
    // MARK: - Delete
    
    /**
     Delete an athletic.
     - parameter athletic: Athletic to delete.
     - returns: If an error occurred, the error's type is returned.
     */
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
     */
    func refresh() {
        for athletic in coreDataStack.entities.allAthletics {
            if let value = athletic.getEvolution(for: Date().today) {
                evolutionDatasManager.create(for: athletic, value: value, date: Date().today)
                evolutionDatasManager.delete(athletic.evolutionDatasToClean(for: Date().today))
            }
        }
    }
}

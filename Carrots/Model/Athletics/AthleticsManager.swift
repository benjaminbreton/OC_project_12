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
    var today: Date { Calendar.current.startOfDay(for: Date()) }
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Evolution
    
    /**
     Every day, athletics can get evolution of their performances during the last 30 days. This method updates athletics evolution if necessary.
     */
    func getEvolution() {
        for athletic in coreDataStack.entities.allAthletics {
            if let value = athletic.getEvolution(for: today) {
                let evolutionData = EvolutionData(context: coreDataStack.viewContext)
                evolutionData.athletic = athletic
                evolutionData.date = today
                evolutionData.value = value
                deleteEvolutionDatas(athletic.evolutionDatasToClean(for: today))
            }
        }
    }
    
    private func deleteEvolutionDatas(_ evolutionDatas: [EvolutionData]) {
        if evolutionDatas.count > 0 {
            for evolutionData in evolutionDatas {
                coreDataStack.viewContext.delete(evolutionData)
            }
        }
    }
    
    // MARK: - Add
    
    /// Add athletic to the game.
    /// - parameter name: Athletic's name to add.
    /// - parameter completionHandler: Code to execute when athletic has been added.
    func add(name: String, image: Data?, pot: Pot) -> ApplicationErrors? {
        if alreadyExists(name) { return .log(.existingAthletic) }
        create(name: name, image: image, pot: pot)
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
    private func create(name: String, image: Data?, pot: Pot) {
        let athletic = Athletic(context: coreDataStack.viewContext)
        athletic.creationDate = Date()
        athletic.willBeDeleted = false
        athletic.pot = pot
        modify(athletic, name: name, image: image)
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
        deleteEvolutionDatas(athletic.evolutionDatas)
        coreDataStack.viewContext.delete(athletic)
        coreDataStack.saveContext()
        return nil
    }
    /// Delete performances in which the only athletic is an athletic to delete, without cancelling earned points.
    /// - parameter athletic: The athletic to be deleted.
//    private func deletePerformances(_ athletic: Athletic) {
//        let performances: [Performance] = athletic.performances
//        for performance in performances {
//            let athletics: [Athletic] = performance.athletics
//            if athletics.count == 1 && athletics[0] == athletic {
//                performPerformanceDeletion(performance, cancelPoints: false)
//            }
//        }
//    }
    
    
    
}

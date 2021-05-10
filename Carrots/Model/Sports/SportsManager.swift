//
//  SportsManager.swift
//  Carrots
//
//  Created by Benjamin Breton on 07/05/2021.
//

import Foundation
import CoreData

class SportsManager {
    let coreDataStack: CoreDataStack
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    
    // MARK: - Add
    
    /// Add sport to the game.
    /// - parameter name: Sport's name to create.
    /// - parameter unityType: Sport's unity type.
    /// - parameter valueForOnePoint: Unity type's value to get one point.
    /// - parameter completionHandler: Code to execute when sport has been added.
    func add(name: String?, icon: String?, unityType: Int16?, valueForOnePoint: [String?]) -> ApplicationErrors? {
        guard let name = name, let icon = icon, let unityType = unityType else { return nil }
        if alreadyExists(name) { return .log(.existingSport) }
        let sport = Sport(context: coreDataStack.viewContext)
        sport.update(name: name, icon: icon, unityType: unityType, valueForOnePoint: valueForOnePoint)
        coreDataStack.saveContext()
        return nil
    }
    /// Check if a sport exists in sports.
    /// - parameter name: Sport's name to check.
    /// - returns: A boolean which indicates whether the sport exists or not.
    private func alreadyExists(_ name: String) -> Bool {
        for existingSport in coreDataStack.entities.allSports {
            if existingSport.name == name {
                return true
            }
        }
        return false
    }
    
    
    // MARK: - Modify
    
    func modify(_ sport: Sport, name: String, icon: String?, unityType: Int16?,  valueForOnePoint: [String?]) -> ApplicationErrors? {
        let existingName = sport.name == name ? false : alreadyExists(name)
        guard !existingName else { return .log(.existingSport) }
        sport.update(name: name, icon: icon, unityType: unityType, valueForOnePoint: valueForOnePoint)
        coreDataStack.saveContext()
        return nil
    }
    
    // MARK: - Delete
    
    /// Delete a sport.
    /// - parameter sport: Sport to delete.
    /// - parameter completionHandler: Code to execute when athletic has been deleted.
    func delete(_ sport: Sport) -> ApplicationErrors? {
        coreDataStack.viewContext.delete(sport)
        coreDataStack.saveContext()
        return nil
    }
    
}

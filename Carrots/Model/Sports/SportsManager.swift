//
//  SportsManager.swift
//  Carrots
//
//  Created by Benjamin Breton on 07/05/2021.
//

import Foundation
import CoreData

class SportsManager {
    
    // MARK: - Properties
    
    /// Coredatastack used to save and load datas from CoreData.
    let coreDataStack: CoreDataStack
    
    // MARK: - Init
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Add
    
    /**
     Add sport.
     - parameter name: Sport's name.
     - parameter icon: Sport's icon's character.
     - parameter unityType: The unity used to measure a sport's performance.
     - parameter pointsConversion: The needed performance's value to get one point, or the earned points each time this sport has been made.
     - returns: If an error occurred, the error's type is returned.
     */
    func add(name: String, icon: String, unityType: Sport.UnityType, pointsConversion: [String?]) -> ApplicationErrors? {
        if alreadyExists(name) { return .log(.existingSport) }
        let sport = Sport(context: coreDataStack.viewContext)
        sport.update(name: name, icon: icon, unityType: unityType.int16, pointsConversion: pointsConversion)
        coreDataStack.saveContext()
        return nil
    }
    /**
     Check if a sport exists in sports.
     - parameter name: Sport's name to check.
     - returns: A boolean which indicates whether the sport exists or not.
     */
    private func alreadyExists(_ name: String) -> Bool {
        for existingSport in coreDataStack.entities.allSports {
            if existingSport.name == name {
                return true
            }
        }
        return false
    }
    
    // MARK: - Modify
    
    /**
     Modify sport.
     - parameter sport: The sport to modify.
     - parameter name: Sport's name.
     - parameter icon: Sport's icon's character.
     - parameter unityType: The unity used to measure a sport's performance.
     - parameter pointsConversion: The needed performance's value to get one point, or the earned points each time this sport has been made.
     - returns: If an error occurred, the error's type is returned.
     */
    func modify(_ sport: Sport, name: String, icon: String, unityType: Sport.UnityType,  pointsConversion: [String?]) -> ApplicationErrors? {
        let existingName = sport.name == name ? false : alreadyExists(name)
        guard !existingName else { return .log(.existingSport) }
        sport.update(name: name, icon: icon, unityType: unityType.int16, pointsConversion: pointsConversion)
        coreDataStack.saveContext()
        return nil
    }
    
    // MARK: - Delete
    
    /**
     Delete sport.
     - parameter sport: The sport to delete.
     - returns: If an error occurred, the error's type is returned.
     */
    func delete(_ sport: Sport) -> ApplicationErrors? {
        coreDataStack.viewContext.delete(sport)
        coreDataStack.saveContext()
        return nil
    }
}

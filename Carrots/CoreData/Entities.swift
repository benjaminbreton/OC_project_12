//
//  Entities.swift
//  Carrots
//
//  Created by Benjamin Breton on 07/05/2021.
//

import Foundation
import CoreData

class Entities {
    
    // MARK: - CoreDataStack properties
    
    private let context: NSManagedObjectContext
    
    // MARK: - Entities properties
    
    var commonPot: Pot? {
        let result: [CommonPot] = getEntities(by: "pot.creationDate", ascending: true)
        guard result.count == 1, let pot = result[0].pot else {
            if result.count == 0 {
                ApplicationErrors.log(.noCommonPot)
            } else {
                ApplicationErrors.log(.severalCommonPots(result.count))
                for commonPot in result {
                    if let pot = commonPot.pot, pot.points > 0 {
                        let potsToDelete = result.map({ $0 == commonPot ? nil : $0 }).compactMap({ $0 })
                        for potToDelete in potsToDelete {
                            context.delete(potToDelete)
                        }
                        try? context.save()
                        return pot
                    }
                }
                for index in 1...result.count - 1 {
                    context.delete(result[index])
                }
                try? context.save()
                return result[0].pot
            }
            return nil
        }
        return pot
    }
    var allAthletics: [Athletic] { getEntities(by: "name", ascending: true) }
    var allSports: [Sport] { getEntities(by: "name", ascending: true) }
    var allPerformances: [Performance] { getEntities(by: "date", ascending: false) }
    var allPots: [Pot] { getEntities(by: "creationDate", ascending: true) }
    var insertedObjects: [NSManagedObject] { Array(context.insertedObjects) }
    
    // MARK: - Init
    
    init(_ context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Get entities
    
    func getEntities<Entity: NSManagedObject>(by descriptor: String? = nil, ascending: Bool? = nil) -> [Entity] {
        guard let request = Entity.fetchRequest() as? NSFetchRequest<Entity> else { return [] }
        if let descriptor = descriptor, let ascending = ascending {
            request.sortDescriptors = [NSSortDescriptor(key: descriptor, ascending: ascending)]
        }
        guard let result = try? context.fetch(request) else { return [] }
        return result
    }
}

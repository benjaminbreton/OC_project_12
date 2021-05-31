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
        let result: [CommonPot] = getEntities()
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
                for potToDelete in result {
                    context.delete(potToDelete)
                }
                try? context.save()
            }
            return nil
        }
        return pot
    }
    var allAthletics: [Athletic] { getEntities(by: "name", ascending: true) }
    var allSports: [Sport] { getEntities(by: "name", ascending: true) }
    var allPerformances: [Performance] { getEntities(by: "date", ascending: false) }
    var allPots: [Pot] { getEntities(by: "creationDate", ascending: true) }
    
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
    
    func getPerformances<Entity: NSManagedObject>(of item: Entity) -> [Performance] {
        if let athletic = item as? Athletic {
            return getAthleticPerformances(of: athletic)
        }
        if let sport = item as? Sport {
            return getSportPerformances(of: sport)
        }
        return []
    }
    private func getAthleticPerformances(of athletic: Athletic) -> [Performance] {
        let all = allPerformances
        var performances: [Performance] = []
        for performance in all {
            for performanceAthletic in performance.athletics {
                if athletic == performanceAthletic {
                    performances.append(performance)
                    break
                }
            }
        }
        return performances
    }
    private func getSportPerformances(of sport: Sport) -> [Performance] {
        let all = allPerformances
        var performances: [Performance] = []
        for performance in all {
            if let performanceSport = performance.sport, performanceSport == sport {
                performances.append(performance)
            }
        }
        return performances
    }
}

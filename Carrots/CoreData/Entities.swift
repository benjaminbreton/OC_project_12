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
        let predicate = NSPredicate(format: "owner == %@", 0)
        let request: NSFetchRequest<Pot> = Pot.fetchRequest()
        request.predicate = predicate
        guard let result = try? context.fetch(request) else {
            return nil
        }
        guard result.count == 1 else { return nil }
        return result[0]
    }
    var allAthletics: [Athletic] { getEntities(by: "name", ascending: true) }
    var allSports: [Sport] { getEntities(by: "name", ascending: true) }
    var allPerformances: [Performance] { getEntities(by: "date", ascending: false) }
    
    // MARK: - Init
    
    init(_ context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Get entities
    
    func getEntities<Entity: NSManagedObject>(by descriptor: String, ascending: Bool) -> [Entity] {
        guard let request = Entity.fetchRequest() as? NSFetchRequest<Entity> else { return [] }
        request.sortDescriptors = [NSSortDescriptor(key: descriptor, ascending: ascending)]
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

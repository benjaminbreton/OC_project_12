//
//  EvolutionDatasManager.swift
//  Carrots
//
//  Created by Benjamin Breton on 17/05/2021.
//

import Foundation
import CoreData

final class EvolutionDatasManager {
    
    // MARK: - Property
    
    /// Coredatastack used to save and load datas from CoreData.
    private let coreDataStack: CoreDataStack
    /// The setted date for today.
    private let today: Date
    
    // MARK: - Init
    
    init(_ coreDataStack: CoreDataStack, today: Date) {
        self.coreDataStack = coreDataStack
        self.today = today
    }
    
    // MARK: - Creation
    
    /**
     Create an evolution data.
     - parameter owner: The object for which an evolution data has to be made.
     - parameter value: The value of the evolution data.
     - parameter date: The date of the evolution data.
     */
    func create<Owner: NSManagedObject>(for owner: Owner, value: Double, date: Date) {
        let evolutionData = EvolutionData(context: coreDataStack.viewContext)
        evolutionData.date = date
        if let athletic = owner as? Athletic { evolutionData.athletic = athletic }
        if let pot = owner as? Pot { evolutionData.pot = pot }
        evolutionData.value = value
    }
    
    // MARK: - Deletion
    
    /**
     Delete evolution datas.
     - parameter evolutionDatas: Evolution datas to delete.
     */
    func delete(_ evolutionDatas: [EvolutionData]) {
        if evolutionDatas.count > 0 {
            for evolutionData in evolutionDatas {
                coreDataStack.viewContext.delete(evolutionData)
            }
        }
    }
    
    // MARK: - Update
    
    /**
     Method called to create evolution datas of an entity.
     - parameter entity: The entity for which evolution datas have to be created.
     - parameter date: The last day of the 30 days evolution.
     */
    func handleEvolutions(of entity: EvolutionDatasContainer, until date: Date) {
        guard let entityNS = entity as? NSManagedObject else { return }
        if let value = getEvolution(for: entity, until: date) {
            create(for: entityNS, value: value, date: date)
            delete(evolutionDatasToClean(for: entity, until: date))
        }
    }
    /**
     Check if an evolution has already been created for the current day, and eventually returns the evolution to add.
     - parameter entity: The entity for which evolution datas have to be created.
     - parameter date: Date of the evolution to get.
     - returns: The number of points per hour, or *nil* if an evolution has already been created for the date entered in parameter.
     */
    private func getEvolution(for entity: EvolutionDatasContainer, until date: Date) -> Double? {
        guard entity.evolutionDatas.count > 0, let creationDate = entity.creationDate, let lastEvolution = entity.evolutionDatas.last, let lastEvolutionDate = lastEvolution.date, lastEvolutionDate < date else { return nil }
        return getEvolutionValue(for: entity, from: creationDate, to: date)
    }
    /**
     Returns the number of points earned per hour.
     - parameter entity: The entity for which evolution datas have to be created.
     - parameter start: Date of the pot's creation.
     - parameter end: Date of the evolution to get.
     - returns: The number of points per hour.
     */
    private func getEvolutionValue(for entity: EvolutionDatasContainer, from start: Date, to end: Date) -> Double {
        let interval = DateInterval(start: start, end: end)
        return allPoints(of: entity) / interval.duration * 3600
    }
    /**
     Returns all earned points of an EvolutionDatasContainer.
     - parameter entity: The EvolutionDatasContainer.
     - returns: All earned points.
     */
    private func allPoints(of entity: EvolutionDatasContainer) -> Double {
        allPerformances(of: entity).map({ Double($0.potAddings )}).reduce(0, +)
    }
    /**
     Returns all performances of an EvolutionDatasContainer.
     - parameter entity: The EvolutionDatasContainer.
     - returns: All performances.
     */
    private func allPerformances(of entity: EvolutionDatasContainer) -> [Performance] {
        if let entity = entity as? PerformancesContainer {
            // return all performances of the container
            return entity.performances
        } else if let pot = entity as? Pot, let owner = pot.owner {
            // return all performances of the owner where the points have been added to this pot
            return owner.performances.map({ $0.addedToCommonPot ? nil : $0 }).compactMap({ $0 })
        }
        // case of common pot : return all performances added to the common pot
        return coreDataStack.entities.allPerformances.map({ $0.addedToCommonPot ? $0 : nil }).compactMap({ $0 })
    }
    /**
     Keep datas for the last 30 days, plus one.
     - parameter entity: The entity for which evolution datas have to be deleted.
     - returns: The datas to keep.
     */
    private func evolutionDatasToClean(for entity: EvolutionDatasContainer, until date: Date) -> [EvolutionData] {
        let date = date - 30 * 24 * 3600
        var evolutionDatas: [EvolutionData] = []
        for evolutionData in entity.evolutionDatas {
            guard let evolutionDate = evolutionData.date else { return [] }
            if evolutionDate <= date {
                evolutionDatas.append(evolutionData)
            }
        }
        guard evolutionDatas.count > 0 else { return evolutionDatas }
        evolutionDatas.remove(at: evolutionDatas.count - 1)
        return evolutionDatas
    }
}

protocol PerformancesContainer {
    var performances: [Performance] { get }
}



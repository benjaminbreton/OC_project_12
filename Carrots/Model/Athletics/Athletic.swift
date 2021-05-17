//
//  Athletic.swift
//  Carrots
//
//  Created by Benjamin Breton on 25/03/2021.
//

import Foundation
import CoreData

// MARK: - Properties

public class Athletic: NSManagedObject {
    /// All points earned by the Athletic.
    var allPoints: Double {
        if performances.count > 0 {
            return Double(performances.map({ $0.potAddings }).reduce(0, +))
        } else {
            return 0
        }
    }
    /// All points earned by the Athletic AND added to his own pot.
    var allPotPoints: Double {
        if performances.count > 0 {
            return Double(performances.map({ $0.addedToCommonPot ? 0 : $0.potAddings }).reduce(0, +))
        } else {
            return 0
        }
    }
    public override var description: String { name ?? "" }
    var performances: [Performance] {
        guard let performancesSet = performancesSet, let performances = performancesSet.allObjects as? [Performance] else {
            return []
        }
        return performances
    }
    func update(name: String?, image: Data?) {
        self.name = name
        self.image = image
    }
}


// MARK: - Evolution datas

extension Athletic {
    /// Pot's evolution datas.
    var evolutionDatas: [EvolutionData] {
        guard let evolutionSet = evolutionDatasSet, let evolutions = evolutionSet.allObjects as? [EvolutionData] else {
            return []
        }
        return evolutions.sorted {
            $0.date ?? Date() < $1.date ?? Date()
        }
    }
    /**
     Check if an evolution has already been created for the current day, and eventually returns the evolution to add.
     - parameter date: Date of the evolution to get.
     - returns: The number of points per hour, or *nil* if an evolution has already been created for the date entered in parameter.
     */
    func getEvolution(for date: Date) -> Double? {
        let calendar = Calendar.current
        if evolutionDatas.count > 0 {
            guard let creationDate = creationDate, let lastEvolution = evolutionDatas.last, let lastEvolutionDate = lastEvolution.date, lastEvolutionDate < date else { return nil }
            return getEvolutionValue(from: creationDate, to: date)
        } else if let creationDate = creationDate, calendar.startOfDay(for: creationDate) < date {
            return getEvolutionValue(from: creationDate, to: date)
        } else {
            return nil
        }
    }
    /**
     Returns the number of points earned per hour.
     - parameter start: Date of the pot's creation.
     - parameter end: Date of the evolution to get.
     - returns: The number of points per hour.
     */
    private func getEvolutionValue(from start: Date, to end: Date) -> Double {
        let interval = DateInterval(start: start, end: end)
        return allPoints / interval.duration * 3600
    }
    /**
     Keep datas for the last 30 days, plus one.
     - returns: The left datas.
     */
    func evolutionDatasToClean(for date: Date) -> [EvolutionData] {
        let date = date - 30 * 24 * 3600
        var evolutionDatas: [EvolutionData] = []
        for evolutionData in evolutionDatas {
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


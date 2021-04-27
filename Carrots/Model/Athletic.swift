//
//  Athletic.swift
//  Carrots
//
//  Created by Benjamin Breton on 25/03/2021.
//

import Foundation
import CoreData
public class Athletic: NSManagedObject {
    var allPoints: Double {
        if performances.count > 0 {
            return performances.map({ $0.addedToCommonPot ? 0 : $0.potAddings }).reduce(0, +)
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
    var evolutionDatas: [EvolutionData] {
        guard let evolutionSet = evolutionDatasSet, let evolutions = evolutionSet.allObjects as? [EvolutionData] else {
            return []
        }
        return evolutions
    }
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
    private func getEvolutionValue(from start: Date, to end: Date) -> Double {
        let interval = DateInterval(start: start, end: end)
        return allPoints / interval.duration
    }
    
}

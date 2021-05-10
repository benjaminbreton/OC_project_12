//
//  Pot.swift
//  Carrots
//
//  Created by Benjamin Breton on 23/03/2021.
//

import Foundation
import CoreData

// MARK: - Properties

public class Pot: NSManagedObject {
    public override var description: String {
        guard let name = owner?.name else { return "Common pot" }
        return name
    }
    var allPoints: Double {
        if let owner = owner {
            return owner.allPoints
        } else {
            let request: NSFetchRequest<Performance> = Performance.fetchRequest()
            let predicate = NSPredicate(format: "addedToCommonPot == %@", true)
            request.predicate = predicate
            guard let performances = try? managedObjectContext?.fetch(request) else { return 0 }
            let points = performances.map({ Double($0.potAddings) * Double($0.initialAthleticsCount) }).reduce(0, +)
            return points
        }
    }
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        guard let result = formatter.string(from: NSNumber(value: computedAmount)) else { return "0.00" }
        return result
    }
    var computedAmount: Double = 0
}

// MARK: - Points

extension Pot {
    
    func changePoints(_ count: Int, with pointsForOneEuro: Int) {
        points += Double(count)
        computeAmount(with: pointsForOneEuro)
    }
    
    func fixPoints(with pointsForOneEuro: Int) {
        computeAmount(with: pointsForOneEuro)
        self.amount = computedAmount
        points = 0
    }

}

// MARK: - Amount

extension Pot {
    
    func changeAmount(_ count: Double, with pointsForOneEuro: Int) {
        amount += count
        computeAmount(with: pointsForOneEuro)
    }
    
    private func computeAmount(with pointsForOneEuro: Int) {
        let euroPoints: Double = points / Double(pointsForOneEuro == 0 ? 1 : pointsForOneEuro)
        let newAmount = euroPoints + amount
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        guard let stringNumber = formatter.string(from: NSNumber(value: newAmount)), let result = Double(stringNumber) else { return }
        computedAmount = result
    }
    
}

// MARK: - Evolution

extension Pot {
    
    var evolution: EvolutionType {
        evolutionDatas.count >= 2 ? EvolutionType.determinate(from: evolutionDatas[evolutionDatas.count - 2].value, to: evolutionDatas[evolutionDatas.count - 1].value) : .same
    }
    
    enum EvolutionType {
        case up, same, down
        var int16: Int16 {
            switch self {
            case .up:
                return 1
            case .down:
                return 2
            default:
                return 0
            }
        }
        var image: (name: String, colorInt16: Int16) {
            let name: String
            switch self {
            case .up:
                name = "arrow.up.right.square"
            case .same:
                name = "arrow.right.square"
            case .down:
                name = "arrow.down.right.square"
            }
            return (name: name, colorInt16: int16)
        }
        static func determinate(from lastEvolution: Double, to newEvolution: Double) -> EvolutionType {
            if newEvolution > lastEvolution {
                return .up
            } else if newEvolution < lastEvolution {
                return .down
            } else {
                return .same
            }
        }
    }
}

// MARK: - Evolution datas

extension Pot {
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

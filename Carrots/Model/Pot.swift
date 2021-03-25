//
//  Pot.swift
//  Carrots
//
//  Created by Benjamin Breton on 23/03/2021.
//

import Foundation
import CoreData
public class Pot: NSManagedObject {
    func addPoints(_ count: Double) {
        let countCheck = convertPoints(count)
        amount += countCheck.amount
        points += countCheck.leftPoints
        let pointsCheck = convertPoints(points)
        amount += pointsCheck.amount
    }
    private func convertPoints(_ count: Double) -> (amount: Double, leftPoints: Double) {
        let amount: Int = Int(count / 1000)
        let leftPoints = Int(count) % 1000
        return (amount: Double(amount), leftPoints: Double(leftPoints))
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
public class Athletic: NSManagedObject {
    func getPotInformations(for nextDate: Date) -> (amount: String, predictedAmount: String, evolution: Pot.EvolutionType) {
        guard let pot = pot, let performancesSet = performances, let performances = performancesSet.allObjects as? [Performance], let creationDate = pot.creationDate, let lastEvolutionDate = pot.lastEvolutionDate else { return (amount: "---", predictedAmount: "---", evolution: .same) }
        // formatter
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = Locale.current
        // evolution
        let evolution: Double
        let evolutionType: Pot.EvolutionType
        let evolutionDate: Date
        if lastEvolutionDate + 24 * 3600 > Date() {
            // evolution doesn't have to be updated
            evolution = pot.lastEvolution
            evolutionType = pot.evolutionType.potEvolutionType
            evolutionDate = lastEvolutionDate
        } else {
            // update evolution
            evolutionDate = Date()
            let allPoints: Double
            if performances.count > 0 {
                allPoints = performances.map({ $0.addedToCommonPot ? 0 : $0.potAddings }).reduce(0, +)
            } else {
                allPoints = 0
            }
            let duration = DateInterval(start: creationDate, end: evolutionDate).duration
            evolution = duration/allPoints
            evolutionType = Pot.EvolutionType.determinate(from: pot.lastEvolution, to: evolution)
            pot.lastEvolution = evolution
            pot.lastEvolutionDate = evolutionDate
            pot.evolutionType = evolutionType.int16
        }
        
        // predicted amount
        let nextStep = DateInterval(start: evolutionDate, end: nextDate).duration
        let amountToAdd = nextStep * evolution
        let nextAmount = pot.amount + amountToAdd
        guard let amount: String = formatter.string(from: NSNumber(value: pot.amount)), let predictedAmount: String = formatter.string(from: NSNumber(value: nextAmount)) else { return (amount: "", predictedAmount: "", evolution: .same) }
        
        if creationDate + 24 * 3600 > Date() {
            return (amount: amount, predictedAmount: "No prediction can't be done for the first 24 hours.", evolution: .same)
        }
        return (amount: amount, predictedAmount: predictedAmount, evolution: evolutionType)
    }
    

}

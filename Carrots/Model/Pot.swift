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






// MARK: - Get statistics

extension Pot {
    
    // MARK: - Stats typealias
    
    typealias EvolutionInformations = (evolution: Double, evolutionType: Pot.EvolutionType, evolutionDate: Date)
    typealias Statistics = (amount: String, predictedAmount: String, evolution: Pot.EvolutionType, predictedAmountDate: String)
    
    // MARK: - Get stats
    
    /// Get athletic's or commonpot's statistics.
    /// - parameter athletic: Athletic for whom statistics have to be getted, default value : nil to get commonpot's statistics.
    /// - parameter completionHandler: Actions to do with the returned stats.
    func getStatistics(allCommonPoints: Double = 0, predictedAmountDate: Date, completionHandler: (Statistics) -> Void) {
        // get pot informations
        guard let creationDate = creationDate else { return }
        // get evolution
        let athletic = owner
        let evolutionInformations = getEvolutionInformations(athletic: athletic, allCommonPoints: allCommonPoints)
        let evolution: Double = evolutionInformations.evolution
        let evolutionType: Pot.EvolutionType = evolutionInformations.evolutionType
        let evolutionDate: Date = evolutionInformations.evolutionDate
        // get predicted amount
        let predictedAmountDate = predictedAmountDate > Date() ? predictedAmountDate : predictedAmountDate + 30 * 24 * 3600
        let nextAmount = getPredictedAmount(from: evolutionDate, with: evolution, predictedAmountDate: predictedAmountDate)
        // format amounts
        let amountFormatter = getAmountFormatter()
        guard let amount: String = amountFormatter.string(from: NSNumber(value: amount)),
              let predictedAmount: String = amountFormatter.string(from: NSNumber(value: nextAmount)) else { return }
        // format date
        let dateFormatter = getDateFormatter()
        let formattedPredictedAmountDate = dateFormatter.string(from: predictedAmountDate)
        // return stats
        if creationDate + 24 * 3600 > Date() {
            completionHandler((amount: amount, predictedAmount: "No prediction can't be done for the first 24 hours.", evolution: .same, predictedAmountDate: "---"))
            return
        }
        completionHandler((amount: amount, predictedAmount: predictedAmount, evolution: evolutionType, predictedAmountDate: formattedPredictedAmountDate))
    }
    
    
    private func getEvolutionInformations(athletic: Athletic?, allCommonPoints: Double) -> EvolutionInformations {
        guard let creationDate = creationDate, let lastEvolutionDate = lastEvolutionDate else { return (evolution: 0, evolutionType: .same, evolutionDate: Date()) }
        if lastEvolutionDate + 24 * 3600 > Date() {
            // evolution doesn't have to be updated
            return (evolution: lastEvolution, evolutionType: evolutionType.potEvolutionType, evolutionDate: lastEvolutionDate)
        } else {
            // update evolution
            let evolutionDate = Date()
            let allPoints: Double
            if let athletic = athletic {
                allPoints = athletic.allPoints
            } else {
                allPoints = allCommonPoints
            }
            let duration = DateInterval(start: creationDate, end: evolutionDate).duration
            let evolution = duration/allPoints
            let evolutionType = Pot.EvolutionType.determinate(from: lastEvolution, to: evolution)
            self.lastEvolution = evolution
            self.lastEvolutionDate = evolutionDate
            self.evolutionType = evolutionType.int16
            return (evolution: evolution, evolutionType: evolutionType, evolutionDate: evolutionDate)
        }
    }
    private func getPredictedAmount(from evolutionDate: Date, with evolution: Double, predictedAmountDate: Date) -> Double {
        let nextStep = DateInterval(start: evolutionDate, end: predictedAmountDate).duration
        let amountToAdd = nextStep * evolution
        let nextAmount = amount + amountToAdd
        return nextAmount
    }
    private func getAmountFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = Locale.current
        return formatter
    }
    private func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }
}

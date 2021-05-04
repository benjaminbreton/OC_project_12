//
//  Pot.swift
//  Carrots
//
//  Created by Benjamin Breton on 23/03/2021.
//

import Foundation
import CoreData
public class Pot: NSManagedObject {
    public override var description: String {
        guard let name = owner?.name else { return "Common pot" }
        return name
    }
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: amount)) ?? ""
    }
    var formattedEvolutionType: EvolutionType {
        evolutionType.potEvolutionType
    }
    func addPoints(_ count: Int64) {
        let countCheck = convertPoints(Double(count))
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

// MARK: - Get statistics

extension Pot {
    
    // MARK: - Stats typealias
    
    typealias EvolutionInformations = (evolution: Double, evolutionType: Pot.EvolutionType, evolutionDate: Date)
    typealias Statistics = (amount: String, predictedAmount: String, evolution: Pot.EvolutionType, predictedAmountDate: Date)
    
    // MARK: - Get stats
    
    /// Get athletic's or common pot's statistics.
    /// - parameter athletic: Athletic for whom statistics have to be getted, default value : nil to get commonpot's statistics.
    /// - parameter completionHandler: Actions to do with the returned stats.
    func getStatistics(allCommonPoints: Double = 0, predictedAmountDate: Date, completionHandler: (Statistics) -> Void) {
        // get pot informations
        guard let creationDate = creationDate, creationDate + 24 * 3600 < Date() else {
            let formattedAmount = getFormattedAmount(amount)
            completionHandler((amount: formattedAmount, predictedAmount: "No prediction can't be done for the first 24 hours.", evolution: .same, predictedAmountDate: Date()))
            return
        }
        // get evolution
        let evolutionInformations = getEvolutionInformations(allCommonPoints: allCommonPoints)
        let evolution: Double = evolutionInformations.evolution
        let evolutionType: Pot.EvolutionType = evolutionInformations.evolutionType
        let evolutionDate: Date = evolutionInformations.evolutionDate
        // get predicted amount
        let predictedAmountDate = predictedAmountDate > Date() ? predictedAmountDate : predictedAmountDate + 30 * 24 * 3600
        let predictedAmount = getPredictedAmount(from: evolutionDate, with: evolution, predictedAmountDate: predictedAmountDate)
        // format amounts
        let formattedAmount = getFormattedAmount(amount)
        let formattedPredictedAmount = getFormattedAmount(predictedAmount)
        // return stats
        completionHandler((amount: formattedAmount, predictedAmount: formattedPredictedAmount, evolution: evolutionType, predictedAmountDate: predictedAmountDate))
    }
    /// Get evolution informations.
    /// - parameter allCommonPoints: All points added to the common pot.
    /// - returns: Evolution informations : evolution, evolution's type (up, down or same), and evolution date (when evolution has been calculated).
    private func getEvolutionInformations(allCommonPoints: Double) -> EvolutionInformations {
        guard let creationDate = creationDate, let lastEvolutionDate = lastEvolutionDate else { return (evolution: 0, evolutionType: .same, evolutionDate: Date()) }
        if lastEvolutionDate + 24 * 3600 > Date() {
            // evolution doesn't have to be updated, returns old values
            return (evolution: lastEvolution, evolutionType: evolutionType.potEvolutionType, evolutionDate: lastEvolutionDate)
        } else {
            // update evolution
            // get new evolution date : beginning of current day
            let evolutionDate = getTodayBeginning()
            // get all earned points by the owner
            let allPoints: Double
            if let athletic = owner {
                allPoints = athletic.allPoints
            } else {
                allPoints = allCommonPoints
            }
            // get duration during which points have been earned
            let duration = DateInterval(start: creationDate, end: evolutionDate).duration
            // compute evolution
            let evolution = allPoints / duration
            let evolutionType = Pot.EvolutionType.determinate(from: lastEvolution, to: evolution)
            self.lastEvolution = evolution
            self.lastEvolutionDate = evolutionDate
            self.evolutionType = evolutionType.int16
            return (evolution: evolution, evolutionType: evolutionType, evolutionDate: evolutionDate)
        }
    }
    /// Get predicted amount of the pot regarding evolution.
    /// - parameter evolutionDate: When evolution has been calculated.
    /// - parameter evolution: Calculated evolution based on earned points.
    /// - parameter predictAmountDate: Prediction's date.
    /// - returns: The computed amount on the prediction's date.
    private func getPredictedAmount(from evolutionDate: Date, with evolution: Double, predictedAmountDate: Date) -> Double {
        let nextStep = DateInterval(start: evolutionDate, end: predictedAmountDate).duration
        let amountToAdd = nextStep * evolution
        let nextAmount = amount + amountToAdd
        return nextAmount
    }
    /// Get formatted amount.
    /// - parameter amount: Amount to format.
    /// - returns: Formatted amount.
    private func getFormattedAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        guard let result = formatter.string(from: NSNumber(value: amount)) else { return "" }
        return result
    }
    /// Get start of day for today.
    /// - returns: Start of today.
    private func getTodayBeginning() -> Date {
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: Date())
        return date
    }
}

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
    /// Pot's description
    public override var description: String {
        guard let name = owner?.name else { return "pots.commonPot".localized }
        return "\("pots.nameStart".localized)\(name)\("pots.nameEnd".localized)"
    }
    /// All points added to the pot.
    var allPoints: Double {
        if let owner = owner {
            return owner.allPotPoints
        } else {
            let request: NSFetchRequest<Performance> = Performance.fetchRequest()
            let predicate = NSPredicate(format: "addedToCommonPot == YES")
            request.predicate = predicate
            guard let performances = try? managedObjectContext?.fetch(request) else { return 0 }
            let points = performances.map({ Double($0.potAddings) * Double($0.initialAthleticsCount) }).reduce(0, +)
            return points
        }
    }
    /// Amount to display.
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        guard let result = formatter.string(from: NSNumber(value: computedAmount)) else { return "0.00" }
        return result
    }
    /// Prediction amount to display.
    var formattedPredictionAmount: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        guard let result = formatter.string(from: NSNumber(value: computedPredictionAmount)) else { return "0.00" }
        return result
    }
    /// Computed amount with the compute function.
    var computedAmount: Double = 0
    /// Computed prediction amount with the compute function.
    var computedPredictionAmount: Double = 0
}

// MARK: - Refresh

extension Pot {
    /**
     Refresh the computed amount.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     - parameter predictionDate: Setted date to predict a pot's amount.
     */
    func refresh(with moneyConversion: Int, for predictionDate: Date) {
        computeAmount(with: moneyConversion, for: predictionDate)
    }
}

// MARK: - Points

extension Pot {
    /**
     Change the pot's points.
     - parameter count: Number of points to add.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     - parameter predictionDate: Setted date to predict a pot's amount.
     */
    func changePoints(_ count: Int, with moneyConversion: Int, for predictionDate: Date) {
        points += Double(count)
        computeAmount(with: moneyConversion, for: predictionDate)
    }
    /**
     Method to call to block points changings.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     - parameter predictionDate: Setted date to predict a pot's amount.
     */
    func fixPoints(with moneyConversion: Int, for predictionDate: Date) {
        computeAmount(with: moneyConversion, for: predictionDate)
        self.amount = computedAmount
        points = 0
    }

}

// MARK: - Amount

extension Pot {
    /**
     Change the pot's amount.
     - parameter count: Amount to add.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     - parameter predictionDate: Setted date to predict a pot's amount.
     */
    func changeAmount(_ count: Double, with moneyConversion: Int, for predictionDate: Date) {
        amount += count
        computeAmount(with: moneyConversion, for: predictionDate)
    }
    /**
    Compute the amount regarding the points and the saved amount.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     - parameter predictionDate: Setted date to predict a pot's amount.
     */
    private func computeAmount(with moneyConversion: Int, for predictionDate: Date) {
        let newAmount = amount + convertPointsInMoney(points, with: moneyConversion)
        let newPredictionAmount = newAmount + computePredictedGain(with: moneyConversion, for: predictionDate)
        // format the result
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en-EN")
        guard let stringRegularAmount = formatter.string(from: NSNumber(value: newAmount)), let regularAmount = Double(stringRegularAmount), let stringPredictionAmount = formatter.string(from: NSNumber(value: newPredictionAmount)), let predictionAmount = Double(stringPredictionAmount) else { return }
        computedAmount = regularAmount
        computedPredictionAmount = predictionAmount
    }
    /**
     Compute the predicted gain regarding the earned points since the athletic's creation and the prediction date.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     - parameter predictionDate: Setted date to predict a pot's amount.
     */
    private func computePredictedGain(with moneyConversion: Int, for predictionDate: Date) -> Double {
        guard predictionDate > Date().today, let evolution = evolutionDatas.last else { return 0 }
        let interval = DateInterval(start: Date().today, end: predictionDate)
        let points = interval.duration / 3600 * evolution.value
        return convertPointsInMoney(points, with: moneyConversion)
    }
    /**
     Convert points in money regarding the money conversion rate.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     */
    private func convertPointsInMoney(_ points: Double, with moneyConversion: Int) -> Double {
        return points / Double(moneyConversion == 0 ? 1 : moneyConversion)
    }
    
}

// MARK: - Evolution

extension Pot {
    /// Evolution type to display on the pots page.
    var evolution: EvolutionType {
        return evolutionDatas.count >= 2 ? EvolutionType.determinate(from: evolutionDatas[evolutionDatas.count - 2].value, to: evolutionDatas[evolutionDatas.count - 1].value) : .same
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

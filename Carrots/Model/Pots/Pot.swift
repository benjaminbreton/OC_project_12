//
//  Pot.swift
//  Carrots
//
//  Created by Benjamin Breton on 23/03/2021.
//

import Foundation
import CoreData

// MARK: - Properties

public class Pot: NSManagedObject, EvolutionDatasContainer {
    
    /// Pot's description, aka its owner's name.
    public override var description: String {
        guard let name = owner?.name else { return "pots.commonPot".localized }
        return "\(name)"
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
    /// Evolution type to display on the pots page.
    var evolution: EvolutionType {
        return evolutionDatas.count >= 2 ? EvolutionType.determinate(from: evolutionDatas[evolutionDatas.count - 2].value, to: evolutionDatas[evolutionDatas.count - 1].value) : .same
    }
    /// Pot's evolution datas.
    var evolutionDatas: [EvolutionData] {
        guard let evolutionSet = evolutionDatasSet, let evolutions = evolutionSet.allObjects as? [EvolutionData] else {
            return []
        }
        return evolutions.sorted {
            $0.date ?? Date() < $1.date ?? Date()
        }
    }
    var isFirstDay: Bool {
        guard let date = creationDate else { return false }
        return Calendar.current.startOfDay(for: date) == Date().today
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
    func computeAmount(with moneyConversion: Int, for predictionDate: Date) {
        // get new amount
        let newAmount = amount + convertPointsInMoney(points, with: moneyConversion)
        // get new prediction's amount
        let newPredictionAmount = newAmount + computePredictedGain(with: moneyConversion, for: predictionDate)
        // format the result
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "en-EN")
        guard let stringRegularAmount = formatter.string(from: NSNumber(value: newAmount)), let regularAmount = Double(stringRegularAmount), let stringPredictionAmount = formatter.string(from: NSNumber(value: newPredictionAmount)), let predictionAmount = Double(stringPredictionAmount) else { return }
        // keep and display the result
        computedAmount = regularAmount
        computedPredictionAmount = predictionAmount
    }
    /**
     Compute the predicted gain regarding the earned points since the athletic's creation and the prediction date.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     - parameter predictionDate: Setted date to predict a pot's amount.
     */
    private func computePredictedGain(with moneyConversion: Int, for predictionDate: Date) -> Double {
        // get the evolution value (points per hour)
        guard predictionDate > Date().today, let evolution = evolutionDatas.last else { return 0 }
        // get the duration until the prediction date (seconds)
        let interval = DateInterval(start: Date().today, end: predictionDate)
        // apply the value to the duration to get points
        let points = interval.duration / 3600 * evolution.value
        // get and return the points converted in money
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
    
    /**
     Evolution to display on the pots page.
     */
    enum EvolutionType {
        case up, same, down
        /**
         Image's name and color to display regarding the case.
         */
        var image: (name: String, color: String) {
            let name: String
            let color: String
            switch self {
            case .up:
                name = "arrow.up.right.square"
                color = "lightGreen"
            case .same:
                name = "arrow.right.square"
                color = "yellow"
            case .down:
                name = "arrow.down.right.square"
                color = "red"
            }
            return (name: name, color: color)
        }
        /**
         Get evolution's type.
         - parameter lastEvolution: Last evolution's value.
         - parameter newEvolution: New evolution's value.
         - returns: Evolution's type.
         */
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

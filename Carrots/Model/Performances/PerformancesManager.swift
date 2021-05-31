//
//  PerformancesManager.swift
//  Carrots
//
//  Created by Benjamin Breton on 07/05/2021.
//

import Foundation
import CoreData

// MARK: - Property and init

final class PerformancesManager {
    
    /// Coredatastack used to save and load datas from CoreData.
    private let coreDataStack: CoreDataStack
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
}

// MARK: - Add

extension PerformancesManager {
    
    /**
     Add a performance.
     - parameter sport: The sport in which the performance has been made.
     - parameter athletics: Athletics who did the performance.
     - parameter value: The performance's value.
     - parameter addToCommonPot: A boolean which indicates whether the points have to be added to the common pot, or the athletics pots.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     - parameter date: The performance's date.
     - parameter predictionDate: Setted date to predict a pot's amount.
     - returns: If an error occurred, the error's type is returned.
     */
    func add(sport: Sport, athletics: [Athletic], value: [String?], addToCommonPot: Bool, moneyConversion: Int, date: Date, predictionDate: Date) -> ApplicationErrors? {
        guard athletics.count > 0 else { return nil }
        let performance = getNewPerformance(sport: sport, athletics: athletics, value: value, addToCommonPot: addToCommonPot, date: date)
        performance.addPoints(
            to: addToCommonPot ?
                Array.init(repeating: coreDataStack.entities.commonPot, count: athletics.count)
                :
                athletics.map({ $0.pot }),
            with: moneyConversion,
            for: predictionDate)
        return nil
    }
    /**
     Create a performance.
     - parameter sport: The sport in which the performance has been made.
     - parameter athletics: Athletics who did the performance.
     - parameter value: The performance's value.
     - parameter addToCommonPot: A boolean which indicates whether the points have to be added to the common pot, or the athletics pots.
     - parameter date: The performance's date.
     - returns: The created performance.
     */
    private func getNewPerformance(sport: Sport, athletics: [Athletic], value: [String?], addToCommonPot: Bool, date: Date) -> Performance {
        let performance = Performance(context: coreDataStack.viewContext)
        performance.sport = sport
        performance.athleticsSet = NSSet(array: athletics)
        performance.value = sport.unityType.value(for: value)
        performance.addedToCommonPot = addToCommonPot
        performance.date = date
        performance.potAddings = sport.pointsToAdd(for: performance.value)
        performance.initialAthleticsCount = Int16(athletics.count)
        performance.initialUnity = sport.unityInt16
        performance.initialSportIcon = sport.icon
        return performance
    }
}

// MARK: - Delete

extension PerformancesManager {
    
    /**
     Delete a performance.
     - parameter performance: The performance to delete.
     - parameter moneyConversion: Necessary number of points to get one money's
     unity.
     - parameter predictionDate: Setted date to predict a pot's amount.
     */
    func delete(_ performance: Performance, moneyConversion: Int, predictionDate: Date) -> ApplicationErrors? {
        performPerformanceDeletion(performance, cancelPoints: true, moneyConversion: moneyConversion, predictionDate: predictionDate)
        return nil
    }
    /**
     Delete an athletic's participation on a performance.
     - parameter performance: The performance.
     - parameter athletic: The athletic for whom the performance has to be deleted.
     - parameter moneyConversion: Necessary number of points to get one money's
     unity.
     - parameter predictionDate: Setted date to predict a pot's amount.
     */
    func delete(_ performance: Performance, of athletic: Athletic, moneyConversion: Int, predictionDate: Date) -> ApplicationErrors? {
        let newArray = performance.athletics.map({ $0 == athletic ? nil : $0 }).compactMap({ $0 })
        if newArray.count > 0 {
            performance.athleticsSet = NSSet(array: newArray)
            performance.cancelPoints(to: [performance.addedToCommonPot ? coreDataStack.entities.commonPot : athletic.pot], with: moneyConversion, for: predictionDate)
            performance.initialAthleticsCount -= 1
        } else {
            performPerformanceDeletion(performance, cancelPoints: true, moneyConversion: moneyConversion, predictionDate: predictionDate)
        }
        return nil
    }
    /**
     Delete a performance.
     - parameter performance: The performance to delete.
     - parameter cancelPoints: Boolean which indicates whether the points earned by the performance have to be cancelled or not.
     - parameter moneyConversion: Necessary number of points to get one money's
     unity.
     - parameter predictionDate: Setted date to predict a pot's amount.
     */
    private func performPerformanceDeletion(_ performance: Performance, cancelPoints: Bool, moneyConversion: Int, predictionDate: Date) {
        if cancelPoints {
            performance.cancelPoints(
                to:
                                        
                    performance.addedToCommonPot ?
                                        
                    Array(repeating: coreDataStack.entities.commonPot, count: Int(performance.initialAthleticsCount))
                    :
                                        
                    performance.athletics.map({ $0.pot }),
                with: moneyConversion,
                for: predictionDate)
        }
        coreDataStack.viewContext.delete(performance)
    }
}

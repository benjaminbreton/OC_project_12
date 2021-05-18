//
//  PerformancesManager.swift
//  Carrots
//
//  Created by Benjamin Breton on 07/05/2021.
//

import Foundation
import CoreData

class PerformancesManager {
    
    let coreDataStack: CoreDataStack
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Add
    
    /// Add performance.
    /// - parameter sport: Performance's sport.
    /// - parameter athletics: Athletics who made the performance.
    /// - parameter value: Performance's value, depending on sport's unit type.
    /// - parameter addToCommonPot: Boolean which indicates whether the points have to be added to the common pot or not.
    /// - parameter completionHandler: Actions to do once performance has been added.
    func add(sport: Sport, athletics: [Athletic], value: [String?], addToCommonPot: Bool, pointsForOneEuro: Int, date: Date, predictionDate: Date) -> ApplicationErrors? {
        guard athletics.count > 0 else { return .log(.performanceWithoutAthletic) }
        let performance = getNewPerformance(sport: sport, athletics: athletics, value: value, addToCommonPot: addToCommonPot, date: date)
        performance.addPoints(
            to: addToCommonPot ?
                Array.init(repeating: coreDataStack.entities.commonPot, count: athletics.count)
                :
                athletics.map({ $0.pot }),
            with: pointsForOneEuro,
            for: predictionDate)
        coreDataStack.saveContext()
        return nil
    }
    /// Get new performance with choosen parameters.
    /// - parameter sport: Performance's sport.
    /// - parameter athletics: Athletics who made the performance.
    /// - parameter value: Performance's value, depending on sport's unit type.
    /// - parameter coreDataStack: Coredatastack in which the performance has to be made.
    /// - returns: The created performance.
    private func getNewPerformance(sport: Sport, athletics: [Athletic], value: [String?], addToCommonPot: Bool, date: Date) -> Performance {
        let performance = Performance(context: coreDataStack.viewContext)
        performance.sport = sport
        performance.athleticsSet = NSSet(array: athletics)
        performance.value = sport.unityType.value(for: value)
        performance.addedToCommonPot = addToCommonPot
        performance.date = date
        performance.potAddings = sport.pointsToAdd(for: performance.value)
        performance.initialAthleticsCount = Int16(athletics.count)
        return performance
    }
    
    // MARK: - Delete
    
    /// Delete performance.
    /// - parameter performance: Performance to delete.
    func delete(_ performance: Performance, pointsForOneEuro: Int, predictionDate: Date) -> ApplicationErrors? {
        performPerformanceDeletion(performance, cancelPoints: true, pointsForOneEuro: pointsForOneEuro, predictionDate: predictionDate)
        return nil
    }
    func delete<T: NSManagedObject>(of item: T, pointsForOneEuro: Int, predictionDate: Date) -> ApplicationErrors? {
        if let athletic = item as? Athletic {
            for performance in athletic.performances {
                performPerformanceDeletion(performance, cancelPoints: false, pointsForOneEuro: pointsForOneEuro, predictionDate: predictionDate)
            }
        }
        if let sport = item as? Sport {
            for performance in sport.performances {
                performPerformanceDeletion(performance, cancelPoints: false, pointsForOneEuro: pointsForOneEuro, predictionDate: predictionDate)
            }
        }
        return nil
    }
    /// Delete performance.
    /// - parameter performance: Performance to delete.
    /// - parameter cancelPoints: Boolean which indicates whether the points earned by the performance have to be cancelled or not.
    private func performPerformanceDeletion(_ performance: Performance, cancelPoints: Bool, pointsForOneEuro: Int, predictionDate: Date) {
        if cancelPoints {
            performance.cancelPoints(
                to:
                                        
                    performance.addedToCommonPot ?
                                        
                    Array(repeating: coreDataStack.entities.commonPot, count: Int(performance.initialAthleticsCount))
                    :
                                        
                    performance.athletics.map({ $0.pot }),
                with: pointsForOneEuro,
                for: predictionDate)
        }
        coreDataStack.viewContext.delete(performance)
        coreDataStack.saveContext()
    }
}

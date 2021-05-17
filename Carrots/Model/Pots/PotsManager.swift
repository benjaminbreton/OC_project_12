//
//  PotsManager.swift
//  Carrots
//
//  Created by Benjamin Breton on 10/05/2021.
//

import Foundation
import CoreData
class PotsManager {
    let coreDataStack: CoreDataStack
    let evolutionDatasManager: EvolutionDatasManager
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.evolutionDatasManager = EvolutionDatasManager(coreDataStack)
    }

    // MARK: - Creation

    /// Create a new pot for its future owner.
    /// - parameter athletic: Future pot's owner (nil to create the common pot).
    /// - returns: The new pot.
    func create(today: Date) -> Pot {
        let pot = Pot(context: coreDataStack.viewContext)
        pot.amount = 0
        pot.creationDate = today
        pot.points = 0
        evolutionDatasManager.create(for: pot, value: 0, date: today)
        coreDataStack.saveContext()
        return pot
    }
    
    // MARK: - Money
    
    /// Add money to a pot.
    /// - parameter athletic: The athletic for whom money has to be added (nil to add to the common pot).
    /// - parameter amount: Amount to add.
    func addMoney(for athletic: Athletic?, amount: Double, with pointsForOneEuro: Int) -> ApplicationErrors? {
        let result = getPot(of: athletic)
        switch result {
        case .success(let pot):
            pot.changeAmount(amount, with: pointsForOneEuro)
            return nil
        case . failure(let error):
            return error
        }
    }
    /// Withdraw money to a pot.
    /// - parameter athletic: The athletic for whom money has to be withdrawn (nil to withdraw to the common pot).
    /// - parameter amount: Amount to withdraw.
    func withdrawMoney(for athletic: Athletic?, amount: Double, with pointsForOneEuro: Int) -> ApplicationErrors? {
        let result = getPot(of: athletic)
        switch result {
        case .success(let pot):
            pot.changeAmount(-amount, with: pointsForOneEuro)
            return nil
        case . failure(let error):
            return error
        }
    }
    
    // MARK: - Support
    
    private func getPot(of athletic: Athletic?) -> Result<Pot, ApplicationErrors> {
        if let athletic = athletic {
            guard let pot = athletic.pot else { return .failure(.log(.noPot(athletic))) }
            return .success(pot)
        } else {
            guard let pot = coreDataStack.entities.commonPot else { return .failure(.log(.noPot(nil)))}
            return .success(pot)
        }
    }
    
    // MARK: - Refresh pots
    
    /**
     Refresh pots amount and their evolution if necessary : every day, athletics can get evolution of their performances during the last 30 days.
     - parameter pointsForOneEuro: Needed number of points to get one euro.
     */
    func refresh(with pointsForOneEuro: Int, today: Date) {
        for pot in coreDataStack.entities.allPots {
            pot.refresh(with: pointsForOneEuro)
            print(today)
            if let value = pot.getEvolution(for: today) {
                print("create pot evolution")
                evolutionDatasManager.create(for: pot, value: value, date: today)
                evolutionDatasManager.delete(pot.evolutionDatasToClean(for: today))
            }
        }
    }
    
}

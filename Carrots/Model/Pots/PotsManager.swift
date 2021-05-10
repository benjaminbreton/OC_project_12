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
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    // MARK: - Creation

    /// Create a new pot for its future owner.
    /// - parameter athletic: Future pot's owner (nil to create the common pot).
    /// - returns: The new pot.
    func create() -> Pot {
        let pot = Pot(context: coreDataStack.viewContext)
        pot.amount = 0
        pot.creationDate = Date()
        pot.evolutionType = Pot.EvolutionType.same.int16
        pot.lastEvolution = 0
        pot.lastEvolutionDate = Date()
        pot.points = 0
        coreDataStack.saveContext()
        return pot
    }
    
    // MARK: - Money
    
    /// Add money to a pot.
    /// - parameter athletic: The athletic for whom money has to be added (nil to add to the common pot).
    /// - parameter amount: Amount to add.
    func addMoney(for athletic: Athletic?, amount: Double) -> ApplicationErrors? {
        let result = getPot(of: athletic)
        switch result {
        case .success(let pot):
            pot.amount += amount
            return nil
        case . failure(let error):
            return error
        }
    }
    /// Withdraw money to a pot.
    /// - parameter athletic: The athletic for whom money has to be withdrawn (nil to withdraw to the common pot).
    /// - parameter amount: Amount to withdraw.
    func withdrawMoney(for athletic: Athletic?, amount: Double) -> ApplicationErrors? {
        let result = getPot(of: athletic)
        switch result {
        case .success(let pot):
            pot.amount -= amount
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
    
}

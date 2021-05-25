//
//  PotsManager.swift
//  Carrots
//
//  Created by Benjamin Breton on 10/05/2021.
//

import Foundation
import CoreData
class PotsManager {
    
    // MARK: - Properties
    
    /// Coredatastack used to save and load datas from CoreData.
    let coreDataStack: CoreDataStack
    /// Used to create and delete evolution datas.
    let evolutionDatasManager: EvolutionDatasManager
    
    // MARK: - Init
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.evolutionDatasManager = EvolutionDatasManager(coreDataStack)
    }

    // MARK: - Creation
    
    /**
     Create a new pot.
     - parameter date: The pot's creation date.
     - returns: The new pot.
     */
    func create(for date: Date = Date().today) -> Pot {
        let pot = Pot(context: coreDataStack.viewContext)
        pot.amount = 0
        pot.creationDate = date
        pot.points = 0
        evolutionDatasManager.create(for: pot, value: 0, date: Date().today)
        return pot
    }
    /**
     Create the common pot.
     */
    func createCommonPot() {
        let pot = create()
        let commonPot = CommonPot(context: coreDataStack.viewContext)
        commonPot.pot = pot
    }
    
    // MARK: - Money
    
    /**
     Add money to a pot.
     - parameter athletic: The pot's owner, set *nil* to modify the common pot.
     - parameter amount: The amount to add.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     - parameter predictionDate: Setted date to predict a pot's amount.
     - returns: If an error occurred, the error's type is returned.
     */
    func addMoney(for athletic: Athletic?, amount: Double, with moneyConversion: Int, predictionDate: Date) -> ApplicationErrors? {
        guard let pot = getPot(of: athletic) else { return nil }
        pot.changeAmount(amount, with: moneyConversion, for: predictionDate)
        return nil
    }
    /**
     Withdraw money from a pot.
     - parameter athletic: The pot's owner, set *nil* to modify the common pot.
     - parameter amount: The amount or withdraw.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     - parameter predictionDate: Setted date to predict a pot's amount.
     - returns: If an error occurred, the error's type is returned.
     */
    func withdrawMoney(for athletic: Athletic?, amount: Double, with moneyConversion: Int, predictionDate: Date) -> ApplicationErrors? {
        guard let pot = getPot(of: athletic) else { return nil }
        pot.changeAmount(-amount, with: moneyConversion, for: predictionDate)
        return nil
    }
    
    // MARK: - Support
    
    /**
     Get a pot regarding its owner.
     - parameter athletic: The pot's owner, *nil* to get the common pot.
     - returns: The pot.
     */
    private func getPot(of athletic: Athletic?) -> Pot? {
        if let athletic = athletic {
            guard let pot = athletic.pot else { return nil }
            return pot
        } else {
            guard let pot = coreDataStack.entities.commonPot else { return nil }
            return pot
        }
    }
    
    // MARK: - Refresh pots
    
    /**
     Refresh pots amount and their evolution if necessary : every day, athletics can get evolution of their performances during the last 30 days.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     - parameter predictionDate: Setted date to predict a pot's amount.
     */
    func refresh(with moneyConversion: Int, for predictionDate: Date) {
        for pot in coreDataStack.entities.allPots {
            if let value = pot.getEvolution(for: Date().today) {
                evolutionDatasManager.create(for: pot, value: value, date: Date().today)
                evolutionDatasManager.delete(pot.evolutionDatasToClean(for: Date().today))
            }
            pot.computeAmount(with: moneyConversion, for: predictionDate)
        }
    }
    
}

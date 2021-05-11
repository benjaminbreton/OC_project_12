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
    
    var today: Date { Calendar.current.startOfDay(for: Date()) }
    
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
        pot.points = 0
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
    
    // MARK: - Evolution
    
    private func deleteEvolutionDatas(_ evolutionDatas: [EvolutionData]) {
        if evolutionDatas.count > 0 {
            for evolutionData in evolutionDatas {
                coreDataStack.viewContext.delete(evolutionData)
            }
        }
    }
    
    func deleteEvolutionDatas(of athletic: Athletic? = nil) -> ApplicationErrors? {
        let evolutionDatas = athletic == nil ? coreDataStack.entities.commonPot?.evolutionDatas ?? [] : athletic?.pot?.evolutionDatas ?? []
        if evolutionDatas.count > 0 {
            for evolutionData in evolutionDatas {
                coreDataStack.viewContext.delete(evolutionData)
            }
        }
        return nil
    }
    
    // MARK: - Refresh pots
    
    /**
     Refresh pots amount and their evolution if necessary : every day, athletics can get evolution of their performances during the last 30 days.
     - parameter pointsForOneEuro: Needed number of points to get one euro.
     */
    func refresh(with pointsForOneEuro: Int) {
        for pot in coreDataStack.entities.allPots {
            pot.refresh(with: pointsForOneEuro)
            if let value = pot.getEvolution(for: today) {
                let evolutionData = EvolutionData(context: coreDataStack.viewContext)
                evolutionData.pot = pot
                evolutionData.date = today
                evolutionData.value = value
                deleteEvolutionDatas(pot.evolutionDatasToClean(for: today))
            }
        }
    }
    
}

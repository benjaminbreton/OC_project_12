//
//  EvolutionDatasManager.swift
//  Carrots
//
//  Created by Benjamin Breton on 17/05/2021.
//

import Foundation
import CoreData

class EvolutionDatasManager {
    
    // MARK: - Property
    
    /// Coredatastack used to save and load datas from CoreData.
    let coreDataStack: CoreDataStack
    
    // MARK: - Init
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Methods
    
    /**
     Create an evolution data.
     - parameter owner: The object for which an evolution data has to be made.
     - parameter value: The value of the evolution data.
     - parameter date: The date of the evolution data.
     */
    func create<Owner: NSManagedObject>(for owner: Owner, value: Double, date: Date) {
        let evolutionData = EvolutionData(context: coreDataStack.viewContext)
        evolutionData.date = date
        if let athletic = owner as? Athletic { evolutionData.athletic = athletic }
        if let pot = owner as? Pot { evolutionData.pot = pot }
        evolutionData.value = value
    }
    
    /**
     Delete evolution datas.
     - parameter evolutionDatas: Evolution datas to delete.
     */
    func delete(_ evolutionDatas: [EvolutionData]) {
        if evolutionDatas.count > 0 {
            for evolutionData in evolutionDatas {
                coreDataStack.viewContext.delete(evolutionData)
            }
        }
    }
}

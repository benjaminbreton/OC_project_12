//
//  EvolutionDatasManager.swift
//  Carrots
//
//  Created by Benjamin Breton on 17/05/2021.
//

import Foundation
import CoreData

class EvolutionDatasManager {
    let coreDataStack: CoreDataStack
    
    init(_ coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func create<Owner: NSManagedObject>(for owner: Owner, value: Double, date: Date) {
        let evolutionData = EvolutionData(context: coreDataStack.viewContext)
        evolutionData.date = date
        if let athletic = owner as? Athletic { evolutionData.athletic = athletic }
        if let pot = owner as? Pot { evolutionData.pot = pot }
        evolutionData.value = value
    }
    
    func delete(_ evolutionDatas: [EvolutionData]) {
        if evolutionDatas.count > 0 {
            for evolutionData in evolutionDatas {
                coreDataStack.viewContext.delete(evolutionData)
            }
        }
    }
    
    
}

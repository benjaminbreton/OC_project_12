//
//  Athletic.swift
//  Carrots
//
//  Created by Benjamin Breton on 25/03/2021.
//

import Foundation
import CoreData
public class Athletic: NSManagedObject {
    var allPoints: Double {
        if performances.count > 0 {
            return Double(performances.map({ $0.addedToCommonPot ? 0 : $0.potAddings }).reduce(0, +))
        } else {
            return 0
        }
    }
    public override var description: String { name ?? "" }
    var performances: [Performance] {
        guard let performancesSet = performancesSet, let performances = performancesSet.allObjects as? [Performance] else {
            return []
        }
        return performances
    }
    var evolutionDatas: [EvolutionData] {
        pot?.evolutionDatas ?? []
    }
    
    func update(name: String?, image: Data?) {
        self.name = name
        self.image = image
    }
}

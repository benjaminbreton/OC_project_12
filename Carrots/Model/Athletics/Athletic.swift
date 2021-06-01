//
//  Athletic.swift
//  Carrots
//
//  Created by Benjamin Breton on 25/03/2021.
//

import Foundation
import CoreData

// MARK: - Properties

final public class Athletic: NSManagedObject, EvolutionDatasContainer, PerformancesContainer {
    /// The athletic's description, aka his name.
    public override var description: String { name ?? "all.noName".localized }
    /// The athletic's performances, sorted by date.
    var performances: [Performance] {
        performancesSet.getArray().sorted {
            $0.date.unwrapped > $1.date.unwrapped
        }
    }
    /// Athletic's evolution datas.
    var evolutionDatas: [EvolutionData] {
        evolutionDatasSet.getArray().sorted {
            $0.date.unwrapped < $1.date.unwrapped
        }
    }
}

// MARK: - Update

extension Athletic {
    /**
     Update athletic's informations.
     - parameter name: Athletic's name.
     - parameter image: Athletic's image's datas.
     */
    func update(name: String?, image: Data?) {
        self.name = name
        self.image = image
    }
}



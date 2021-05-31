//
//  Athletic.swift
//  Carrots
//
//  Created by Benjamin Breton on 25/03/2021.
//

import Foundation
import CoreData

// MARK: - Properties

final public class Athletic: NSManagedObject, EvolutionDatasContainer {
    /// All points earned by the Athletic.
    var allPoints: Double {
        performances.count > 0 ? Double(performances.map({ $0.potAddings }).reduce(0, +)) : 0
    }
    /// All points earned by the Athletic AND added to his own pot.
    var allPotPoints: Double {
        performances.count > 0 ? Double(performances.map({ $0.addedToCommonPot ? 0 : $0.potAddings }).reduce(0, +)) : 0
    }
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



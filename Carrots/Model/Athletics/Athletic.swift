//
//  Athletic.swift
//  Carrots
//
//  Created by Benjamin Breton on 25/03/2021.
//

import Foundation
import CoreData

// MARK: - Properties

public class Athletic: NSManagedObject, EvolutionDatasContainer {
    
    
    /// All points earned by the Athletic.
    var allPoints: Double {
        if performances.count > 0 {
            return Double(performances.map({ $0.potAddings }).reduce(0, +))
        } else {
            return 0
        }
    }
    /// All points earned by the Athletic AND added to his own pot.
    var allPotPoints: Double {
        if performances.count > 0 {
            return Double(performances.map({ $0.addedToCommonPot ? 0 : $0.potAddings }).reduce(0, +))
        } else {
            return 0
        }
    }
    /// The athletic's description, aka his name.
    public override var description: String { name ?? "all.noName".localized }
    /// The athletic's performances, sorted by date.
    var performances: [Performance] {
        guard let performancesSet = performancesSet, let performances = performancesSet.allObjects as? [Performance] else {
            return []
        }
        return performances.sorted {
            $0.date ?? Date().today > $1.date ?? Date().today
        }
    }
    /// Athletic's evolution datas.
    var evolutionDatas: [EvolutionData] {
        guard let evolutionSet = evolutionDatasSet, let evolutions = evolutionSet.allObjects as? [EvolutionData] else {
            return []
        }
        return evolutions.sorted {
            $0.date ?? Date() < $1.date ?? Date()
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


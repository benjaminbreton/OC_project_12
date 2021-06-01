//
//  PerformancesContainer.swift
//  Carrots
//
//  Created by Benjamin Breton on 01/06/2021.
//

import Foundation
/**
 Protocol used to be sure an entity has a performances array.
 */
protocol PerformancesContainer {
    var performances: [Performance] { get }
}

//
//  EvolutionDatasContainer.swift
//  Carrots
//
//  Created by Benjamin Breton on 31/05/2021.
//

import Foundation
/**
 Protocol used to create evolution datas for coredata entities which contain evolution datas.
 */
protocol EvolutionDatasContainer {
    var creationDate: Date? { get set }
    var evolutionDatas: [EvolutionData] { get }
    var allPoints: Double { get }
}

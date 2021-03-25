//
//  Int16+enumConversion.swift
//  Carrots
//
//  Created by Benjamin Breton on 25/03/2021.
//

import Foundation
extension Int16 {
    var sportUnityType: Sport.UnityType {
        switch self {
        case 1:
            return .kilometers
        case 2:
            return .time
        default:
            return .count
        }
    }
    var potEvolutionType: Pot.EvolutionType {
        switch self {
        case 1:
            return .up
        case 2:
            return .down
        default:
            return .same
        }
    }
}

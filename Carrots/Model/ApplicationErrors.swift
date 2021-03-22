//
//  ApplicationErrors.swift
//  Carrots
//
//  Created by Benjamin Breton on 22/03/2021.
//

import Foundation
enum ApplicationErrors: Error, CustomStringConvertible {
    case existingAthletic, existingSport, unknownSportIndex
    var description: String {
        switch self {
        case .existingAthletic:
            return "Existing athletic's name [F-Game]"
        case .existingSport:
            return "Existing sport's name [F-Game]"
        case .unknownSportIndex:
            return "Sport index out of range [F-Game]"
        }
    }
}

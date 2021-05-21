//
//  ApplicationErrors.swift
//  Carrots
//
//  Created by Benjamin Breton on 22/03/2021.
//

import Foundation
enum ApplicationErrors: Error, CustomStringConvertible {
    // athletics
    case existingAthletic, noPot(Athletic?)
    // sports
    case existingSport, unknownSportIndex
    // performance
    case performanceWithoutAthletic
    // stats
    case cantReturnStats
    // entities
    case noCommonPot, severalCommonPots(Int)
    /// Error's description used in the console for the development team.
    var description: String {
        switch self {
        case .existingAthletic:
            return "Existing athletic's name"
        case .existingSport:
            return "Existing sport's name"
        case .unknownSportIndex:
            return "Sport index out of range"
        case .performanceWithoutAthletic:
            return "Performance without athletic"
        case .cantReturnStats:
            return "Can't return stats"
        case .noCommonPot:
            return "No common pot"
        case .severalCommonPots(let count):
            return "Several common pots: \(count)"
        case .noPot(let athletic):
            guard let athletic = athletic else { return "No common pot." }
            return "No pot for \(athletic.description)."
        }
    }
    /**
     Method called when an error occured to know where the error happends, and what is the error.
     - parameter error: The error.
     - parameter file: File in which the error happends.
     - parameter line: Line in which the error happends.
     - parameter function: Function in which the error happends.
     */
    @discardableResult
    static func log(_ error: ApplicationErrors, file: String = #file, line: Int = #line, function: String = #function) -> ApplicationErrors {
        #if DEBUG
        print("""
            ###> ERROR <###
            ### > \(error),
            ### took place on file \(file),
            ### line \(line),
            ### function \(function).
            ###
            """)
        #endif
        return error
    }
}

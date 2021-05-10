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
extension Error {
    var defaultUserTitle: String { "Error" }
    var defaultUserMessage: String { "An error occurred." }
    var userTitle: String {
        if let error = self as? ApplicationErrors {
            switch error {
            case .existingAthletic:
                return "Unavailable name."
            default:
                return defaultUserTitle
            }
        } else {
            return defaultUserTitle
        }
    }
    var userMessage: String {
        if let error = self as? ApplicationErrors {
            switch error {
            case .existingAthletic:
                return "An athletic already exists with this name. Please choose another."
            default:
                return defaultUserMessage
            }
        } else {
            return defaultUserMessage
        }
    }
    
}

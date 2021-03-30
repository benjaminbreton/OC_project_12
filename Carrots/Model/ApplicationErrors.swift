//
//  ApplicationErrors.swift
//  Carrots
//
//  Created by Benjamin Breton on 22/03/2021.
//

import Foundation
enum ApplicationErrors: Error, CustomStringConvertible {
    case existingAthletic, existingSport, unknownSportIndex, performanceWithoutAthletic, cantReturnStats
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
        }
    }
    static func getErrorWithLog(_ error: ApplicationErrors, file: String = #file, line: Int = #line, function: String = #function) -> ApplicationErrors {
        print("###> ERROR <### Error \(error) took place on file \(file), line \(line), function \(function). ###")
        return error
    }
}

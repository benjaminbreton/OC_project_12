//
//  Error+userDescription.swift
//  Carrots
//
//  Created by Benjamin Breton on 22/03/2021.
//

import Foundation
extension Error {
    var defaultUserTitle: String { "error.default.title".localized }
    var defaultUserMessage: String { "error.default.message".localized }
    var userTitle: String {
        if let error = self as? ApplicationErrors {
            switch error {
            case .existingAthletic:
                return "error.existingAthletic.title".localized
            case .existingSport:
                return "error.existingSport.title".localized
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
                return "error.existingAthletic.message".localized
            case .existingSport:
                return "error.existingSport.message".localized
            default:
                return defaultUserMessage
            }
        } else {
            return defaultUserMessage
        }
    }
}

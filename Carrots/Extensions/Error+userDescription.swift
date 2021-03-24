//
//  Error+userDescription.swift
//  Carrots
//
//  Created by Benjamin Breton on 22/03/2021.
//

import Foundation
extension Error {
    var userDescription: String {
        if let error = self as? ApplicationErrors {
            switch error {
            case .existingAthletic:
                return "This name has already been used for another athletic. Please choose another name."
            case .existingSport:
                return "This name has already been used for another sport. Please choose another name."
            case .performanceWithoutAthletic:
                return "Performance has to have at least one athletic."
            default:
                return "An error occurres."
            }
        } else {
            return "An error occurres."
        }
    }
}

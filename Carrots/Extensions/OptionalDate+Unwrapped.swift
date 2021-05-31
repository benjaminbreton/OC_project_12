//
//  OptionalDate+Unwrapped.swift
//  Carrots
//
//  Created by Benjamin Breton on 31/05/2021.
//

import Foundation
extension Optional where Wrapped == Date {
    var unwrapped: Date {
        guard let date = self else { return Date().today }
        return date
    }
}

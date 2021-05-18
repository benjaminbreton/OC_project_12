//
//  Date+SchemeDates.swift
//  Carrots
//
//  Created by Benjamin Breton on 18/05/2021.
//

import Foundation
extension Date {
    private var dayToAdd: Double {
        #if DAYSAGO45
            return 45
        #elseif DAYSAGO31
            return 31
        #elseif DAYSAGO20
            return 20
        #elseif DAYSAGO18
            return 18
        #elseif DAYSAGO12
            return 12
        #elseif DAYSAGO05
            return 5
        #else
            return 0
        #endif
    }
    var today: Date { Calendar.current.startOfDay(for: now) }
    var now: Date { self - dayToAdd * 24 * 3600 }
}

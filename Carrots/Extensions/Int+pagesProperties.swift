//
//  Int+pagesProperties.swift
//  Carrots
//
//  Created by Benjamin Breton on 30/04/2021.
//

import Foundation
extension Int {
    var tabTitle: String {
        switch self {
        case 0:
            return "pots"
        case 1:
            return "athletics"
        case 2:
            return "sports"
        case 3:
            return "performances"
        default:
            return "error"
        }
    }
    var navigationButtonImage: String {
        switch self {
        case 0:
            return "gear"
        case 1:
            return "person.crop.circle.badge.plus"
        case 3:
            return "gauge.badge.plus"
        case 2:
            return "plus.circle"
        default:
            return "xmark"
        }
    }
}

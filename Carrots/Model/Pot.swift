//
//  Pot.swift
//  Carrots
//
//  Created by Benjamin Breton on 23/03/2021.
//

import Foundation
import CoreData
public class Pot: NSManagedObject {
    var amount: Double {
        guard let game = game else { return 0 }
        var amount = points / game.pointsForOneEuro + addings - withdrawings
        amount = round(amount * 100) / 100
        return amount
    }
}

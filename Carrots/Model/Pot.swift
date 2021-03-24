//
//  Pot.swift
//  Carrots
//
//  Created by Benjamin Breton on 23/03/2021.
//

import Foundation
import CoreData
public class Pot: NSManagedObject {
    func addPoints(_ count: Double) {
        let countCheck = convertPoints(count)
        amount += countCheck.amount
        points += countCheck.leftPoints
        let pointsCheck = convertPoints(points)
        amount += pointsCheck.amount
    }
    private func convertPoints(_ count: Double) -> (amount: Double, leftPoints: Double) {
        let amount: Int = Int(count / 1000)
        let leftPoints = Int(count) % 1000
        return (amount: Double(amount), leftPoints: Double(leftPoints))
    }
}

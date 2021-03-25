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
    enum EvolutionType {
        case up, same, down
        var int16: Int16 {
            switch self {
            case .up:
                return 1
            case .down:
                return 2
            default:
                return 0
            }
        }
        static func determinate(from lastEvolution: Double, to newEvolution: Double) -> EvolutionType {
            if newEvolution > lastEvolution {
                return .up
            } else if newEvolution < lastEvolution {
                return .down
            } else {
                return .same
            }
        }
    }
}


//
//  FakeViewModelToBuildViews.swift
//  Carrots
//
//  Created by Benjamin Breton on 04/04/2021.
//

import Foundation
class FakeViewModel {
    let athletics: [FakeAthletic]
    let commonPot: FakePot?
    var predictedAmountDate: Date
    var formattedPredictedAmountDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: predictedAmountDate)
    }
    init(athletics: [FakeAthletic], commonPot: FakePot, predictedAmountDate: Date) {
        self.athletics = athletics
        self.commonPot = commonPot
        self.predictedAmountDate = predictedAmountDate
    }
    static func create() -> FakeViewModel {
        let commonPot = FakePot(amount: 30, evolutionType: 1)
        var athletics: [FakeAthletic] = []
        let names = ["Lena", "Elo", "Ben", "Dom", "Mar", "Par", "Mic", "Cle", "Ben2"]
        for index in 0..<names.count {
            let pot = FakePot(amount: Double.random(in: 10000...99999), evolutionType: Int16.random(in: 0...2))
            let at = FakeAthletic(name: names[index], pot: pot, performances: nil)
            athletics.append(at)
        }
        return FakeViewModel(athletics: athletics, commonPot: commonPot, predictedAmountDate: Date() + 30 * 24 * 3600)
    }
    static func createEmpty() -> FakeViewModel {
        let commonPot = FakePot(amount: 0, evolutionType: 0)
        return FakeViewModel(athletics: [], commonPot: commonPot, predictedAmountDate: Date() + 30 * 24 * 3600)
    }
    func changePredictedAmountDate(with date: Date) {
        predictedAmountDate = date
    }
}
class FakeAthletic {
    let name: String?
    let image: Data?
    let pot: FakePot?
    let performances: [FakePerformance]?
    init(name: String, pot: FakePot, performances: [FakePerformance]?) {
        self.name = name
        self.pot = pot
        self.performances = performances
        image = nil
        pot.owner = self
    }
}
class FakePot {
    let amount: Double
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: amount)) ?? ""
    }
    let evolutionType: Int16
    var formattedEvolutionType: Pot.EvolutionType {
        evolutionType.potEvolutionType
    }
    var owner: FakeAthletic?
    init(amount: Double, evolutionType: Int16) {
        self.amount = amount
        self.evolutionType = evolutionType
    }
}
class FakeSport {
    
}
class FakePerformance {
    
}

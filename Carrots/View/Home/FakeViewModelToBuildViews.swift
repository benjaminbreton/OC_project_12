//
//  FakeViewModelToBuildViews.swift
//  Carrots
//
//  Created by Benjamin Breton on 04/04/2021.
//

import Foundation
class FakeViewModel {
    let athletics: [FakeAthletic]
    let sports: [FakeSport]
    let commonPot: FakePot?
    var predictedAmountDate: Date
    var formattedPredictedAmountDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: predictedAmountDate)
    }
    init(athletics: [FakeAthletic], commonPot: FakePot, predictedAmountDate: Date, sports: [FakeSport]) {
        self.athletics = athletics
        self.commonPot = commonPot
        self.predictedAmountDate = predictedAmountDate
        self.sports = sports
    }
    static func create() -> FakeViewModel {
        let commonPot = FakePot(amount: 30, evolutionType: 1)
        var athletics: [FakeAthletic] = []
        let names = ["Len", "Elo", "Ben", "Dom", "Mar", "Par", "Mic", "Cle", "Ben2"]
        for index in 0..<names.count {
            let pot = FakePot(amount: Double.random(in: 10000...99999), evolutionType: Int16.random(in: 0...2))
            let at = FakeAthletic(name: names[index], pot: pot, performances: nil)
            athletics.append(at)
        }
        var sports: [FakeSport] = []
        let sport1 = FakeSport(name: "Marche", icon: 15, unity: .kilometers, valueForOnePoint: 1000)
        let sport2 = FakeSport(name: "Rameur", icon: 22, unity: .count, valueForOnePoint: 10)
        let sport3 = FakeSport(name: "Vélo", icon: 25, unity: .time, valueForOnePoint: 360)
        sports.append(sport1)
        sports.append(sport2)
        sports.append(sport3)
        return FakeViewModel(athletics: athletics, commonPot: commonPot, predictedAmountDate: Date() + 30 * 24 * 3600, sports: sports)
    }
    static func createEmpty() -> FakeViewModel {
        let commonPot = FakePot(amount: 0, evolutionType: 0)
        return FakeViewModel(athletics: [], commonPot: commonPot, predictedAmountDate: Date() + 30 * 24 * 3600, sports: [])
    }
    func changePredictedAmountDate(with date: Date) {
        predictedAmountDate = date
    }
}
class FakeAthletic {
    let name: String?
    var image: Data?
    let imageRotation: Double = 0
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
    var name: String?
    var icon: Int16
    var unityInt16: Int16
    var valueForOnePoint: Double
    init(name: String, icon: Int16, unity: Sport.UnityType, valueForOnePoint: Double) {
        self.name = name
        self.icon = icon
        self.unityInt16 = unity.int16
        self.valueForOnePoint = valueForOnePoint
    }
}
class FakePerformance {
    
}

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
    let performances: [FakePerformance]
    var predictedAmountDate: Date
    var formattedPredictedAmountDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: predictedAmountDate)
    }
    init(athletics: [FakeAthletic], commonPot: FakePot, predictedAmountDate: Date, sports: [FakeSport], performances: [FakePerformance]) {
        self.athletics = athletics
        self.commonPot = commonPot
        self.predictedAmountDate = predictedAmountDate
        self.sports = sports
        self.performances = performances
    }
    static func create() -> FakeViewModel {
        let commonPot = FakePot(amount: 30, evolutionType: 1)
        var athletics: [FakeAthletic] = []
        let names = ["Len", "Elo", "Ben", "Dom", "Mar", "Par", "Mic", "Cle", "Ben2"]
        for index in 0..<names.count {
            let pot = FakePot(amount: Double.random(in: 10000...99999), evolutionType: Int16.random(in: 0...2))
            let at = FakeAthletic(name: names[index], pot: pot, performances: [])
            athletics.append(at)
        }
        var sports: [FakeSport] = []
        let sport1 = FakeSport(name: "Marche", icon: "t", unity: .distance, valueForOnePoint: 1000)
        let sport2 = FakeSport(name: "Rameur", icon: "*", unity: .count, valueForOnePoint: 10)
        let sport3 = FakeSport(name: "Vélo", icon: "&", unity: .time, valueForOnePoint: 360)
        sports.append(sport1)
        sports.append(sport2)
        sports.append(sport3)
        let performance1 = FakePerformance(sport: sport1, athletics: athletics, value: Int64.random(in: 1000...10000), addedToCommonPot: true, number: 1)
        let performance2 = FakePerformance(sport: sport2, athletics: athletics, value: Int64.random(in: 1000...10000), addedToCommonPot: false, number: 2)
        let performance3 = FakePerformance(sport: sport3, athletics: athletics, value: Int64.random(in: 1000...10000), addedToCommonPot: false, number: 3)
        let performances = [performance3, performance2, performance1]
        for athletic in athletics {
            athletic.performances = performances
        }
        return FakeViewModel(athletics: athletics, commonPot: commonPot, predictedAmountDate: Date() + 30 * 24 * 3600, sports: sports, performances: performances)
    }
    static func createEmpty() -> FakeViewModel {
        let commonPot = FakePot(amount: 0, evolutionType: 0)
        return FakeViewModel(athletics: [], commonPot: commonPot, predictedAmountDate: Date() + 30 * 24 * 3600, sports: [], performances: [])
    }
    func changePredictedAmountDate(with date: Date) {
        predictedAmountDate = date
    }
}
class FakeAthletic: CustomStringConvertible {
    let name: String?
    var description: String {
        name ?? ""
    }
    var image: Data?
    let imageRotation: Double = 0
    let pot: FakePot?
    var performances: [FakePerformance]
    let creationDate: Date?
    let evolutionDatas: [EvolutionData] = []
    init(name: String, pot: FakePot, performances: [FakePerformance]) {
        self.name = name
        self.pot = pot
        self.performances = performances
        self.creationDate = Date() - 60 * 24 * 3600
        image = nil
        pot.owner = self
    }
}
class FakePot: CustomStringConvertible {
    var description: String {
        guard let name = owner?.name else {
            return "Common pot"
        }
        return "\(name)'s pot"
    }
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
class FakeSport: CustomStringConvertible {
    var description: String {
        guard let name = name else { return "" }
        return name
    }
    
    var name: String?
    var icon: String?
    var unityInt16: Int16
    var valueForOnePoint: Double
    init(name: String, icon: String, unity: Sport.UnityType, valueForOnePoint: Double) {
        self.name = name
        self.icon = icon
        self.unityInt16 = unity.int16
        self.valueForOnePoint = valueForOnePoint
    }
}
class FakePerformance: CustomStringConvertible {
    var description: String { formattedDate }
    let sport: FakeSport?
    let value: Int64
    let potAddings: Int
    let addedToCommonPot: Bool
    let athletics: [FakeAthletic]?
    let date: Date?
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        guard let date = date else { return "" }
        return formatter.string(from: date)
    }
    init(sport: FakeSport, athletics: [FakeAthletic], value: Int64, addedToCommonPot: Bool, number: Double) {
        self.sport = sport
        self.athletics = athletics
        self.value = value
        self.addedToCommonPot = addedToCommonPot
        self.date = Date() + number
        potAddings = Int(value) / Int(sport.valueForOnePoint)
    }
}

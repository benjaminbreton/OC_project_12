//
//  GameDoor.swift
//  Carrots
//
//  Created by Benjamin Breton on 04/05/2021.
//

import Foundation
class GameDoor: ObservableObject {
    @Published private var game: Game
    var athletics: [Athletic] { game.athletics }
    var commonPot: Pot? { game.commonPot }
    var sports: [Sport] { game.sports }
    var performances: [Performance] { game.performances }
    @Published private(set) var askedForReload: Bool = false
    var pointsForOneEuro: String {
        let formatter = NumberFormatter()
        let count = game.settings.pointsForOneEuro
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: count)) ?? "0"
    }
    var predictedAmountDate: Date { game.settings.predictedAmountDate }
    init(_ coreDataStack: CoreDataStack) {
        game = Game(coreDataStack: coreDataStack)
    }
    func addAthletic(name: String?, image: Data?) {
        guard let name = name, !name.isEmpty else { return }
        game.addAthletic(name, image: image)
    }
    func update(_ athletic: Athletic, name: String?, image: Data?) {
        guard let name = name, !name.isEmpty else { return }
        game.updateAthletic(athletic, name: name, image: image)
    }
    func addSport(name: String?, icon: String?, unityType: Int16?, valueForOnePoint: [String?]) {
        guard let name = name, !name.isEmpty, let icon = icon, !icon.isEmpty, let unityType = unityType else { return }
        game.addSport(name, icon: icon, unityType: unityType, valueForOnePoint: valueForOnePoint)
    }
    func update(_ sport: Sport, name: String?, icon: String?, unityType: Int16?, valueForOnePoint: [String?]) {
        guard let name = name, !name.isEmpty, let icon = icon, !icon.isEmpty, let unityType = unityType else { return }
        game.updateSport(for: sport, name: name, icon: icon, unityType: unityType, valueForOnePoint: valueForOnePoint)
    }
    
    func addPerformance(sport: Sport, athletics: [Athletic], value: [String?], addToCommonPot: Bool) {
        game.addPerformance(sport: sport, athletics: athletics, value: value, addToCommonPot: addToCommonPot)
    }
    func delete(_ athletic: Athletic) {
        game.deleteAthletic(athletic)
    }
    func updatePotsGeneralSettings(date: Date, pointsForOneEuro: String?) {
        game.updateSettings(predictedAmountDate: date, pointsForOneEuro: pointsForOneEuro)
    }
    func getError() -> ApplicationErrors? {
        return game.getError()
    }
    func askForReload() {
        askedForReload = true
        askedForReload = false
    }
}

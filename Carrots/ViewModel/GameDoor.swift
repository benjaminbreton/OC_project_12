//
//  GameDoor.swift
//  Carrots
//
//  Created by Benjamin Breton on 04/05/2021.
//

import Foundation
import CoreData
class GameDoor: ObservableObject {
    
    // MARK: - Properties
    
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
    var predictedAmountDate: Date { game.settings.predictionDate }
    var error: ApplicationErrors? { getError() }
    var showHelp: Bool { game.settings.showHelp }
    
    // MARK: - Init
    
    init(_ coreDataStack: CoreDataStack) {
        game = Game(coreDataStack: coreDataStack)
    }
    
    // MARK: - Athletics
    
    func addAthletic(name: String?, image: Data?) {
        guard let name = name, !name.isEmpty else { return }
        game.addAthletic(name: name, image: image)
    }
    func update(_ athletic: Athletic, name: String?, image: Data?) {
        guard let name = name, !name.isEmpty else { return }
        game.modify(athletic, name: name, image: image)
    }
    func delete(_ athletic: Athletic) {
        game.delete(athletic)
    }
    
    // MARK: - Sports
    
    func addSport(name: String?, icon: String?, unityType: Int16?, valueForOnePoint: [String?]) {
        guard let name = name, !name.isEmpty, let icon = icon, !icon.isEmpty, let unityType = unityType else { return }
        game.addSport(name: name, icon: icon, unityType: unityType, valueForOnePoint: valueForOnePoint)
    }
    func update(_ sport: Sport, name: String?, icon: String?, unityType: Int16?, valueForOnePoint: [String?]) {
        guard let name = name, !name.isEmpty, let icon = icon, !icon.isEmpty, let unityType = unityType else { return }
        game.modify(sport, name: name, icon: icon, unityType: unityType, valueForOnePoint: valueForOnePoint)
    }
    func delete(_ sport: Sport) {
        game.delete(sport)
    }
    
    // MARK: - Performances
    
    
    func addPerformance(sport: Sport, athletics: [Athletic], value: [String?], addToCommonPot: Bool) {
        game.addPerformance(sport: sport, athletics: athletics, value: value, addToCommonPot: addToCommonPot)
    }
    func delete(_ performance: Performance) {
        game.delete(performance)
    }
    func deletePerformance(_ performance: Performance, of athletic: Athletic) {
        game.deletePerformance(performance, of: athletic)
    }
    
    // MARK: - Settings
    
    func updatePotsGeneralSettings(date: Date, pointsForOneEuro: String?, showHelp: Bool) {
        game.updateSettings(predictionDate: date, pointsForOneEuro: pointsForOneEuro, showHelp: showHelp)
    }
    
    // MARK: - Errors
    
    private func getError() -> ApplicationErrors? {
        return game.getError()
    }
    
    // MARK: - Refresh
    
    func refresh() {
        game.refresh()
    }
    
    // MARK: - Money
    
    func changeMoney(for athletic: Athletic? = nil, amount: String, operation: Int) {
        if operation == 0 {
            game.addMoney(for: athletic, amount: amount)
        } else {
            game.withdrawMoney(for: athletic, amount: amount)
        }
    }
    
}

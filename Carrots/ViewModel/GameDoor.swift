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
    var predictedAmountDate: Date { game.settings.predictedAmountDate }
    var error: ApplicationErrors? { getError() }
    
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
    func deletePerformances<T: NSManagedObject>(of item: T) {
        game.deletePerformances(of: item)
    }
    
    // MARK: - Settings
    
    func updatePotsGeneralSettings(date: Date, pointsForOneEuro: String?) {
        game.updateSettings(predictedAmountDate: date, pointsForOneEuro: pointsForOneEuro)
    }
    
    // MARK: - Errors
    
    private func getError() -> ApplicationErrors? {
        return game.getError()
    }
    
    // MARK: - Refresh
    
    func refresh() {
        game.refresh()
    }
    
}

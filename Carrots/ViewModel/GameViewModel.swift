//
//  GameViewModel.swift
//  Carrots
//
//  Created by Benjamin Breton on 04/05/2021.
//

import Foundation
import CoreData

// MARK: - Properties

class GameViewModel: ObservableObject {
    /// Instance of game.
    @Published private var game: Game
    /// Athletics list.
    var athletics: [Athletic] { game.athletics }
    /// Common pot.
    var commonPot: Pot? { game.commonPot }
    /// Sports list.
    var sports: [Sport] { game.sports }
    /// Performances list
    var performances: [Performance] { game.performances }
    /// String to display in settings to page to set the money conversion.
    var moneyConversion: String {
        let formatter = NumberFormatter()
        let count = game.settings.moneyConversion
        formatter.maximumFractionDigits = 0
        guard let result = formatter.string(from: NSNumber(value: count)) else { return "0" }
        return result
    }
    /// Setted date to predict a pot's amount.
    var predictionDate: Date { game.settings.predictionDate }
    /// Returned error, if error happened.
    var error: ApplicationErrors? { getError() }
    /// Boolean indicating whether help texts have to be shown or not.
    var showHelp: Bool { game.settings.showHelp }
    /// Boolean indicating whether the pots warning has been validated or not.
    var didValidateWarning: Bool { game.settings.didValidateWarning }

// MARK: - Init

    init(_ coreDataStack: CoreDataStack, today: Date = Date().today) {
        game = Game(coreDataStack: coreDataStack, today: today)
    }
}

// MARK: - Athletics

extension GameViewModel {
    
    /**
     Add athletic.
     - parameter name: Athletic's name.
     - parameter image: Athletic's image's data.
     */
    func addAthletic(name: String?, image: Data?) {
        game.addAthletic(name: name, image: image)
    }
    /**
     Modify an athletic.
     - parameter athletic : Athletic to modify.
     - parameter name: Athletic's name.
     - parameter image: Athletic's image's data.
     */
    func modify(_ athletic: Athletic, name: String?, image: Data?) {
        game.modify(athletic, name: name, image: image)
    }
    /**
     Delete an athletic.
     - parameter athletic: Athletic to delete.
     */
    func delete(_ athletic: Athletic) {
        game.delete(athletic)
    }
}

// MARK: - Sports

extension GameViewModel {

    /**
     Add sport.
     - parameter name: Sport's name.
     - parameter icon: Sport's icon's character.
     - parameter unityType: The unity used to measure a sport's performance.
     - parameter pointsConversion: The needed performance's value to get one point, or the earned points each time this sport has been made.
     */
    func addSport(name: String?, icon: String?, unityType: Sport.UnityType?, pointsConversion: [String?]) {
        game.addSport(name: name, icon: icon, unityType: unityType, pointsConversion: pointsConversion)
    }
    /**
     Modify sport.
     - parameter sport: The sport to modify.
     - parameter name: Sport's name.
     - parameter icon: Sport's icon's character.
     - parameter unityType: The unity used to measure a sport's performance.
     - parameter pointsConversion: The needed performance's value to get one point, or the earned points each time this sport has been made.
     */
    func modify(_ sport: Sport, name: String?, icon: String?, unityType: Sport.UnityType?, pointsConversion: [String?]) {
        game.modify(sport, name: name, icon: icon, unityType: unityType, pointsConversion: pointsConversion)
    }
    /**
     Delete sport.
     - parameter sport: The sport to delete.
     */
    func delete(_ sport: Sport) {
        game.delete(sport)
    }
}

// MARK: - Performances

extension GameViewModel {

    /**
     Add a performance.
     - parameter sport: The sport in which the performance has been made.
     - parameter athletics: Athletics who did the performance.
     - parameter value: The performance's value.
     - parameter addToCommonPot: A boolean which indicates whether the points have to be added to the common pot, or the athletics pots.
     - parameter date: The performance date.
     */
    func addPerformance(sport: Sport, athletics: [Athletic], value: [String?], addToCommonPot: Bool, date: Date = Date().now) {
        game.addPerformance(sport: sport, athletics: athletics, value: value, addToCommonPot: addToCommonPot, date: date)
    }
    /**
     Delete a performance.
     - parameter performance: The performance to delete.
     - parameter athletic: If the performance has to be deleted for a single athletic, set the athletic for whom the performance has to be deleted; otherwise, to delete the performance for all athletics, set *nil*.
     */
    func delete(_ performance: Performance, of athletic: Athletic? = nil) {
        game.delete(performance, of: athletic)
    }
}

// MARK: - Settings

extension GameViewModel {

    /**
     Settings modification.
     - parameter predictionDate: Setted date to predict a pot's amount.
     - parameter moneyConversion: Necessary number of points to get one money's unity.
     - parameter showHelp: Boolean which indicates if help texts have to be shown or not.
     */
    func modifySettings(predictionDate: Date, moneyConversion: String?, showHelp: Bool) {
        game.updateSettings(predictionDate: predictionDate, moneyConversion: moneyConversion, showHelp: showHelp)
    }
    /**
     Validate pots warning, so that the warning will not appear again.
     */
    func validateWarning() {
        game.validateWarning()
    }
    
    
    func setFactorySettingsBack() {
        game.setFactorySettingsBack()
    }
}

// MARK: - Errors

extension GameViewModel {
    
    /**
     Method called by the property *error* when views asked if an error occurred.
     */
    private func getError() -> ApplicationErrors? {
        return game.getError()
    }
}

// MARK: - Refresh

extension GameViewModel {
    
    /**
     Ask to refresh all properties.
     */
    func refresh() {
        game.refresh()
    }
}

// MARK: - Money

extension GameViewModel {
    
    /**
     Add or withdraw money from a pot.
     - parameter athletic: The pot's owner, set *nil* to modify the common pot.
     - parameter amount: The amount to add or withdraw.
     - parameter operation: The operation to perform: 0 = add, 1 = withdraw.
     */
    func changeMoney(for athletic: Athletic? = nil, amount: String, operation: Int) {
        if operation == 0 {
            game.addMoney(for: athletic, amount: amount)
        } else {
            game.withdrawMoney(for: athletic, amount: amount)
        }
    }
    
}

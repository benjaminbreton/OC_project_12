//
//  Game.swift
//  Carrots
//
//  Created by Benjamin Breton on 19/03/2021.
//

import Foundation
import CoreData

// MARK: - Properties

struct Game {
    /// Game's settings saved in Userdefaults.
    private(set) var settings: Settings
    /// Coredatastack used to save and load datas from CoreData.
    private let coreDataStack: CoreDataStack
    /// All  registered athletics.
    private(set) var athletics: [Athletic]
    /// All registered sports.
    private(set) var sports: [Sport]
    /// All registered performances.
    private(set) var performances: [Performance]
    /// Pot used as common pot.
    private(set) var commonPot: Pot?
    /// Error.
    private(set) var error: ApplicationErrors?
    /// All points added to the common pot.
    var allCommonPoints: Double
    /// Last asked statistics.
    var askedStatistics: Pot.Statistics?
}

// MARK: - Init

extension Game {
    /// Create game with the entered Coredatastack.
    /// - parameter coreDataStack: Coredatastack used to save and load datas from CoreData (Coredatastack() by default).
    init(coreDataStack: CoreDataStack = CoreDataStack()) {
        self.settings = Settings()
        self.coreDataStack = coreDataStack
        athletics = []
        sports = []
        performances = []
        allCommonPoints = 0
        commonPot = getCommonPot()
        if settings.gameAlreadyExists {
            athletics = getEntitiesWithDescriptor(with: "name", ascending: true)
            sports = getEntitiesWithDescriptor(with: "name", ascending: true)
            performances = getEntitiesWithDescriptor(with: "date", ascending: false)
            allCommonPoints = getAllCommonPoints()
            getAthleticsEvolution()
        }
        settings.gameAlreadyExists = true
        self.coreDataStack.saveContext()
    }
    
    mutating func updateSettings(predictedAmountDate: Date, pointsForOneEuro: String?) {
        guard let points = pointsForOneEuro, points.count < 5, let intPoints = Int(points) else { return }
        settings.predictedAmountDate = predictedAmountDate
        settings.pointsForOneEuro = intPoints
    }

}

// MARK: - Athletics

extension Game {
    
    // MARK: - Evolution
    
    /**
     Every day, athletics can get evolution of their performances during the last 30 days. This method updates athletics evolution if necessary.
     */
    mutating func getAthleticsEvolution() {
        for athletic in athletics {
            if let value = athletic.getEvolution(for: settings.today) {
                let evolutionData = EvolutionData(context: coreDataStack.viewContext)
                evolutionData.athletic = athletic
                evolutionData.date = settings.today
                evolutionData.value = value
                deleteEvolutionDatas(athletic.evolutionDatasToClean(for: settings.today))
            }
        }
    }
    
    private func deleteEvolutionDatas(_ evolutionDatas: [EvolutionData]) {
        if evolutionDatas.count > 0 {
            for evolutionData in evolutionDatas {
                coreDataStack.viewContext.delete(evolutionData)
            }
        }
    }
    
    // MARK: - Add
    
    /// Add athletic to the game.
    /// - parameter name: Athletic's name to add.
    /// - parameter completionHandler: Code to execute when athletic has been added.
    mutating func addAthletic(_ name: String, image data: Data?) {
        if athleticExists(name) {
            error = .existingAthletic
            return
        }
        addNewAthletic(name, image: data)
        coreDataStack.saveContext()
    }
    /// Check if an athletic exists in athletics.
    /// - parameter name: Athletic's name to check.
    /// - returns: A boolean which indicates whether the athletic exists or not.
    private func athleticExists(_ name: String) -> Bool {
        for existingAthletic in athletics {
            if existingAthletic.name == name {
                return true
            }
        }
        return false
    }
    /// Create an athletic.
    /// - parameter name: Athletic's name to create.
    private mutating func addNewAthletic(_ name: String, image: Data?) {
        let athletic = Athletic(context: coreDataStack.viewContext)
        athletic.creationDate = Date()
        getNewPot(for: athletic)
        updateAthletic(athletic, name: name, image: image)
    }
    
    // MARK: - Update
    
    mutating func updateAthletic(_ athletic: Athletic, name: String, image: Data?) {
        let existingName = athletic.name == name ? false : athleticExists(name)
        guard !existingName else { return }
        athletic.update(name: name, image: image)
        updateProperties()
    }
    
    // MARK: - Delete
    
    /// Delete an athletic
    /// - parameter athletic: Athletic to delete.
    /// - parameter completionHandler: Code to execute when athletic has been deleted.
    mutating func deleteAthletic(_ athletic: Athletic) {
        deleteAthleticPerformances(athletic)
        deleteEvolutionDatas(athletic.evolutionDatas)
        coreDataStack.viewContext.delete(athletic)
        coreDataStack.saveContext()
        updateProperties()
    }
    /// Delete performances in which the only athletic is an athletic to delete, without cancelling earned points.
    /// - parameter athletic: The athletic to be deleted.
    private mutating func deleteAthleticPerformances(_ athletic: Athletic) {
        let performances: [Performance] = athletic.performances
        for performance in performances {
            let athletics: [Athletic] = performance.athletics
            if athletics.count == 1 && athletics[0] == athletic {
                performPerformanceDeletion(performance, cancelPoints: false)
            }
        }
    }
    
    
    
}

// MARK: - Supporting methods
    
extension Game {
    /// Convert a set in an array.
    /// - parameter set: The set to be converted.
    /// - returns: The array based on the set.
    private func getArrayFromSet<T: NSManagedObject>(_ set: NSSet?) -> [T] {
        guard let arraySet = set, let array = arraySet.allObjects as? [T] else { return [] }
        return array
    }
    /// Get a pot from its owner.
    /// - parameter athletic: Pot's owner (nil to get the common pot).
    /// - returns: Asked pot.
    private func getPot(of athletic: Athletic? = nil) -> Pot {
        if let athletic = athletic, let pot = athletic.pot {
            return pot
        } else {
            guard let commonPot = commonPot else { return getNewPot() }
            return commonPot
        }
    }
    /// Create a new pot for its future owner.
    /// - parameter athletic: Future pot's owner (nil to create the common pot).
    /// - returns: The new pot.
    @discardableResult
    private func getNewPot(for athletic: Athletic? = nil) -> Pot {
        let pot = Pot(context: coreDataStack.viewContext)
        pot.amount = 0
        pot.owner = athletic
        pot.creationDate = Date()
        pot.evolutionType = Pot.EvolutionType.same.int16
        pot.lastEvolution = 0
        pot.lastEvolutionDate = Date()
        pot.points = 0
        coreDataStack.saveContext()
        return pot
    }
    private func getEntitiesWithDescriptor<Entity: NSManagedObject>(with descriptor: String, ascending: Bool) -> [Entity] {
        guard let request = Entity.fetchRequest() as? NSFetchRequest<Entity> else { return [] }
        request.sortDescriptors = [NSSortDescriptor(key: descriptor, ascending: ascending)]
        guard let result = try? coreDataStack.viewContext.fetch(request) else { return [] }
        return result
    }
    private func getCommonPot() -> Pot {
        let request: NSFetchRequest<Pot> = Pot.fetchRequest()
        let predicate = NSPredicate(format: "owner == nil")
        request.predicate = predicate
        guard let pots = try? coreDataStack.viewContext.fetch(request), pots.count > 0 else { return getNewPot() }
        return pots[0]
    }
    private func getAllCommonPoints() -> Double {
        if performances.count > 0 {
            return Double(performances.map({ $0.addedToCommonPot ? $0.potAddings : 0 }).reduce(0, +))
        } else {
            return 0
        }
    }
    /// Update athletics array.
    mutating private func updateProperties() {
        athletics = getEntitiesWithDescriptor(with: "name", ascending: true)
        performances = getEntitiesWithDescriptor(with: "date", ascending: false)
        sports = getEntitiesWithDescriptor(with: "name", ascending: true)
        coreDataStack.saveContext()
    }
}

// MARK: - Introduction's methods

extension Game {
    /// Toggle didSeeIntroduction property.
    mutating func introductionHasBeenSeen() {
        settings.didSeeIntroduction = true
    }
}

// MARK: - Sports

extension Game {
    
    // MARK: - Add
    
    /// Add sport to the game.
    /// - parameter name: Sport's name to create.
    /// - parameter unityType: Sport's unity type.
    /// - parameter valueForOnePoint: Unity type's value to get one point.
    /// - parameter completionHandler: Code to execute when sport has been added.
    mutating func addSport(_ name: String?, icon: String?, unityType: Int16?, valueForOnePoint: [String?]) {
        guard let name = name, let icon = icon, let unityType = unityType else { return }
        if sportExists(name) {
            error = .existingSport
            return
        }
        let sport = Sport(context: coreDataStack.viewContext)
        sport.update(name: name, icon: icon, unityType: unityType, valueForOnePoint: valueForOnePoint)
        updateProperties()
    }
    /// Check if a sport exists in sports.
    /// - parameter name: Sport's name to check.
    /// - returns: A boolean which indicates whether the sport exists or not.
    private func sportExists(_ name: String) -> Bool {
        for existingSport in sports {
            if existingSport.name == name {
                return true
            }
        }
        return false
    }

    
    // MARK: - Update sport
    
    mutating func updateSport(for sport: Sport, name: String, icon: String?, unityType: Int16?,  valueForOnePoint: [String?]) {
        let existingName = sport.name == name ? false : sportExists(name)
        guard !existingName else { return }
        sport.update(name: name, icon: icon, unityType: unityType, valueForOnePoint: valueForOnePoint)
        updateProperties()
    }
    
    // MARK: - Delete
    
    /// Delete a sport.
    /// - parameter sport: Sport to delete.
    /// - parameter completionHandler: Code to execute when athletic has been deleted.
    mutating func deleteSport(_ sport: Sport) {
        coreDataStack.viewContext.delete(sport)
        coreDataStack.saveContext()
        updateProperties()
    }
}

// MARK: - Performances

extension Game {
    
    // MARK: - Add
    
    /// Add performance.
    /// - parameter sport: Performance's sport.
    /// - parameter athletics: Athletics who made the performance.
    /// - parameter value: Performance's value, depending on sport's unit type.
    /// - parameter addToCommonPot: Boolean which indicates whether the points have to be added to the common pot or not.
    /// - parameter completionHandler: Actions to do once performance has been added.
    mutating func addPerformance(sport: Sport, athletics: [Athletic], value: [String?], addToCommonPot: Bool) {
        guard athletics.count > 0 else {
            error = .performanceWithoutAthletic
            return
        }
        let performance = getNewPerformance(sport: sport, athletics: athletics, value: value, addToCommonPot: addToCommonPot)
        performance.addPoints(to: addToCommonPot ? Array.init(repeating: commonPot, count: athletics.count) : athletics.map({ $0.pot }))
        coreDataStack.saveContext()
        updateProperties()
    }
    /// Get new performance with choosen parameters.
    /// - parameter sport: Performance's sport.
    /// - parameter athletics: Athletics who made the performance.
    /// - parameter value: Performance's value, depending on sport's unit type.
    /// - parameter coreDataStack: Coredatastack in which the performance has to be made.
    /// - returns: The created performance.
    private func getNewPerformance(sport: Sport, athletics: [Athletic], value: [String?], addToCommonPot: Bool) -> Performance {
        let performance = Performance(context: coreDataStack.viewContext)
        performance.sport = sport
        performance.athleticsSet = NSSet(array: athletics)
        performance.value = sport.unityType.value(for: value)
        performance.addedToCommonPot = addToCommonPot
        performance.date = Date()
        performance.potAddings = sport.pointsToAdd(for: performance.value)
        performance.initialAthleticsCount = Int16(athletics.count)
        return performance
    }
    
    // MARK: - Delete
    
    /// Delete performance.
    /// - parameter performance: Performance to delete.
    mutating func deletePerformance(_ performance: Performance) {
        performPerformanceDeletion(performance, cancelPoints: true)
    }
    /// Delete performance.
    /// - parameter performance: Performance to delete.
    /// - parameter cancelPoints: Boolean which indicates whether the points earned by the performance have to be cancelled or not.
    private mutating func performPerformanceDeletion(_ performance: Performance, cancelPoints: Bool) {
        if cancelPoints {
            performance.cancelPoints(to:
                                        performance.addedToCommonPot ?
                                        Array(repeating: commonPot, count: Int(performance.initialAthleticsCount)) :
                                        performance.athletics.map({ $0.pot }))
        }
        coreDataStack.viewContext.delete(performance)
        coreDataStack.saveContext()
        updateProperties()
    }
}

// MARK: - Statistics

extension Game {
    /// Get athletic's or common pot's statistics.
    /// - parameter athletic: The athletic for whom statistics have to be getted (nil to get common pot's statistics).
    mutating func getStatistics(for athletic: Athletic? = nil) {
        let pot = getPot(of: athletic)
        pot.getStatistics(allCommonPoints: allCommonPoints, predictedAmountDate: settings.predictedAmountDate) { statistics in
            self.askedStatistics = statistics
            self.settings.predictedAmountDate = statistics.predictedAmountDate
            self.coreDataStack.saveContext()
        }
    }
}

// MARK: - Change money

extension Game {
    /// Add money to a pot.
    /// - parameter athletic: The athletic for whom money has to be added (nil to add to the common pot).
    /// - parameter amount: Amount to add.
    mutating func addMoney(for athletic: Athletic? = nil, amount: Double) {
        let pot = getPot(of: athletic)
        pot.amount += amount
        if let athletic = athletic {
            athletic.pot = pot
        } else {
            commonPot = pot
        }
        coreDataStack.saveContext()
    }
    /// Withdraw money to a pot.
    /// - parameter athletic: The athletic for whom money has to be withdrawn (nil to withdraw to the common pot).
    /// - parameter amount: Amount to withdraw.
    mutating func withdrawMoney(for athletic: Athletic? = nil, amount: Double) {
        let pot = getPot(of: athletic)
        pot.amount -= amount
        if let athletic = athletic {
            athletic.pot = pot
        } else {
            commonPot = pot
        }
        coreDataStack.saveContext()
    }
}

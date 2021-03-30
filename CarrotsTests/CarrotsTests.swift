//
//  CarrotsTests.swift
//  CarrotsTests
//
//  Created by Benjamin Breton on 16/03/2021.
//

import XCTest
@testable import Carrots

class CarrotsTests: XCTestCase {
    
    var game: Game?
    
    override func setUp() {
        let coreDataStack = FakeCoreDataStack()
        game = Game(coreDataStack: coreDataStack)
    }
    override func tearDown() {
        game = nil
    }
    
    // MARK: - Game Tests
    
    func testGivenNoGameHasBeenInitializedWhenCreateOneThenGameHasBeenSaved() throws {
        let game = try XCTUnwrap(self.game)
        XCTAssert(game.settings.pointsForOneEuro == 1000)
    }
    
    func testGivenAGameExistsWhenAskForLoadingItThenGameIsLoaded() throws {
        var game = try XCTUnwrap(self.game)
        game.introductionHasBeenSeen()
        tearDown()
        setUp()
        let game2 = try XCTUnwrap(self.game)
        XCTAssert(game2.settings.didSeeIntroduction)
    }
    
    // MARK: - Pot tests
    
    func testGivenPotContainsNothingWhenAskToAddMoneyThenMoneyHasBeenAdded() throws {
        let game = try XCTUnwrap(self.game)
        addAthletic("Ben", to: game)
        game.addMoney(amount: 10)
        game.addMoney(for: game.athletics[0], amount: 50)
        XCTAssert(game.commonPot.amount == 10)
        XCTAssert(game.athletics[0].pot?.amount == 50)
    }
    
    func testGivenPotContainsSomeMoneyWhenAskToWithdrawSomeOfItThenMoneyHasBeenWithdrawn() throws {
        let game = try XCTUnwrap(self.game)
        game.addMoney(amount: 100)
        game.withdrawMoney(amount: 30)
        addAthletic("Ben", to: game)
        game.addMoney(for: game.athletics[0], amount: 50)
        game.withdrawMoney(for: game.athletics[0], amount: 45)
        XCTAssert(game.commonPot.amount == 70)
        XCTAssert(game.athletics[0].pot?.amount == 5)
    }
    
    func testGivenAthleticExistsWhenAskToSeePotStatisticsThenStatisticsAreShown() throws {
        var game = try XCTUnwrap(self.game)
        addAthletic("Ben", to: game)
        game.getStatistics(for: game.athletics[0])
        let statistics = try XCTUnwrap(game.askedStatistics)
        XCTAssert(statistics.amount == "0.00")
        XCTAssert(statistics.evolution == .same)
        XCTAssert(statistics.predictedAmount == "No prediction can't be done for the first 24 hours.")
    }
    
    // MARK: - Athletics tests
    
    func testGivenAGameExistsWhenAskToAddAthleticThenAthleticHasBeenAdded() throws {
        let game = try XCTUnwrap(self.game)
        addAthletic("Ben", to: game)
        XCTAssert(game.athletics.count == 1)
        XCTAssert(game.athletics[0].name == "Ben")
    }
    
    func testGivenAGameWithAthleticExistsWhenAskToAddAthleticWithTheSameNameThenErrorOccurres() throws {
        let game = try XCTUnwrap(self.game)
        addAthletic("Ben", to: game)
        game.addAthletic("Ben") { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                print(error)
                print(error.userDescription)
                XCTAssert(error == .existingAthletic)
            }
        }
    }
    func testGivenAGameWithAthleticsExistsWhenAskToDeleteOneOfThemThenAthleticIsDeleted() throws {
        let game = try XCTUnwrap(self.game)
        addAthletic("Ben", to: game)
        addAthletic("Elo", to: game)
        game.deleteAthletic(game.athletics[0]) { result in
            switch result {
            case .success(let athletics):
                XCTAssert(athletics.count == 1)
                XCTAssert(athletics[0].name == "Elo")
            case . failure(_):
                XCTFail()
            }
        }
    }
    
    // MARK: - Sports tests
    
    func testGivenAGameExistsWhenAskToAddSportThenSportHasBeenAdded() throws {
        let game = try XCTUnwrap(self.game)
        addSport("Marche", to: game)
        XCTAssert(game.sports.count == 1)
        XCTAssert(game.sports[0].name == "Marche")
        XCTAssert(game.sports[0].unityType == .count)
    }
    
    func testGivenASportExistsWhenAskToAddASportWithTheSameNameThenErrorOccures() throws {
        let game = try XCTUnwrap(self.game)
        addSport("Marche", to: game)
        game.addSport("Marche", unityType: .count, valueForOnePoint: 25) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssert(error == .existingSport)
            }
        }
    }
    
    func testGivenSportsExistWhenAskToDeleteOneOfThemThenSportIsDeleted() throws {
        let game = try XCTUnwrap(self.game)
        addSport("Marche", to: game)
        addSport("Rameur", to: game)
        game.deleteSport(game.sports[0]) { result in
            switch result {
            case .success(let sports):
                XCTAssert(sports.count == 1)
                XCTAssert(sports[0].name == "Rameur")
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    // MARK: - Performances tests
    
    func testGivenAGameExistsWhenAskToAddPerformanceThenPerformanceHasBeenAdded() throws {
        let game = try XCTUnwrap(self.game)
        addAthletic("Ben", to: game)
        addSport("Marche", to: game)
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [10], addToCommonPot: true) { result in
            switch result {
            case .success(_):
                let pot = game.commonPot
                XCTAssert(pot.points == 10)
                XCTAssert(game.performances.count == 1)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testGivenAGameExistsWhenAskToAddPerformanceWithoutAthleticThenErrorOccures() throws {
        let game = try XCTUnwrap(self.game)
        addAthletic("Ben", to: game)
        addSport("Marche", to: game)
        game.addPerformance(sport: game.sports[0], athletics: [], value: [10], addToCommonPot: true) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssert(error == .performanceWithoutAthletic)
            }
        }
    }
    
    func testGivenAGameExistsWhenAskToAddPerformanceWithPointsInTheCommonAndIndividualPotsThenPerformanceHasBeenAdded() throws {
        let game = try XCTUnwrap(self.game)
        addAthletic("Ben", to: game)
        addAthletic("Elo", to: game)
        addSport("Marche", to: game)
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [10], addToCommonPot: true) { _ in }
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [10], addToCommonPot: false) { _ in }
        XCTAssert(game.commonPot.points == 20)
        XCTAssert(game.athletics[0].pot?.points == 10)
        XCTAssert(game.athletics[1].pot?.points == 10)
        XCTAssert(game.performances.count == 2)
    }
    
    
    
    func testGivenPerformancesExistWhenAskToDeleteOneOfThemThenPerformanceIsDeleted() throws {
        let game = try XCTUnwrap(self.game)
        addAthletic("Ben", to: game)
        addSport("Marche", to: game)
        addSport("Rameur", to: game)
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [10], addToCommonPot: true) { _ in }
        game.addPerformance(sport: game.sports[1], athletics: game.athletics, value: [100], addToCommonPot: true) { _ in }
        game.deletePerformance(game.performances[0])
        let pot = game.commonPot
        XCTAssert(pot.points == 10)
        XCTAssert(game.performances.count == 1)
    }
    
    func testGivenPerformancesExistWhenAskToDeleteAllOfThemThenPerformancesAreDeleted() throws {
        let game = try XCTUnwrap(self.game)
        addAthletic("Ben", to: game)
        addAthletic("Elo", to: game)
        addSport("Marche", to: game)
        addSport("Rameur", to: game)
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [10], addToCommonPot: true) { _ in }
        game.addPerformance(sport: game.sports[1], athletics: game.athletics, value: [100], addToCommonPot: false) { _ in }
        game.deletePerformance(game.performances[0])
        game.deletePerformance(game.performances[0])
        XCTAssert(game.commonPot.points == 0)
        XCTAssert(game.athletics[0].pot?.points == 0)
        XCTAssert(game.athletics[1].pot?.points == 0)
        XCTAssert(game.performances.count == 0)
    }
    
    // MARK: - Several tests
    
    func testGivenPerformancesExistsWhenAthleticSportAndPerformancesHasBeenDeletedThenTheyAreSuccessfullyDeletedAndPointsTotalIsCorrect() throws {
        let game = try XCTUnwrap(self.game)
        addAthletic("Ben", to: game)
        addAthletic("Elo", to: game)
        let athletic1 = game.athletics[0]
        let athletic2 = game.athletics[1]
        addSport("Marche", to: game)
        let sport = game.sports[0]
        let commonPot = game.commonPot
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [15], addToCommonPot: true) { _ in }
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [30], addToCommonPot: true) { _ in }
        game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [100], addToCommonPot: true) { _ in }
        game.addPerformance(sport: game.sports[0], athletics: [athletic1], value: [50], addToCommonPot: true) { _ in }
        game.deleteAthletic(athletic1) { result in
            switch result {
            case .success(_):
                game.addPerformance(sport: game.sports[0], athletics: game.athletics, value: [70], addToCommonPot: true) { _ in }
                game.deletePerformance(game.performances[2])
                game.deleteSport(sport) { result in
                    switch result {
                    case .success(_):
                        XCTAssert(game.performances.count == 0)
                        XCTAssert(game.athletics.count == 1)
                        XCTAssert(game.athletics == [athletic2])
                        /*
                         points calculation :
                         > pot at the beginning : 0
                         - performance 1, 2 athletics, so :  15 x 2 = +  30pts
                         > total : 30
                         - performance 2, 2 athletics, so :  30 x 2 = +  60pts
                         > total : 90
                         - performance 3, 2 athletics, so : 100 x 2 = + 200pts
                         > total : 290
                         - performance 4, 1 athletic, so :            +  50pts
                         > total: 340
                         - athletic1 deletion : his performances are deleted when he was alone, so the performance 4 is deleted ; but the deletion doesn't change points total
                         > total : 340
                         - performance 5, 1 athletic, so :            +  70pts
                         > total : 410
                         - performance 2 deletion, so :               -  60pts
                         > total : 350
                         - sport deletion : all sport's performances are deleted ; but the deletion doesn't change points total
                         > total : 350
                         */
                        XCTAssert(commonPot.points == 350)
                    case .failure(_):
                        XCTFail()
                    }
                }
            case .failure(_):
                XCTFail()
            }
        }
        
    }
    
    // MARK: - Supporting methods
    
    func addAthletic(_ name: String, to game: Game) {
        game.addAthletic(name) { _ in
            return
        }
    }
    func addSport(_ name: String, to game: Game) {
        game.addSport(name, unityType: .count, valueForOnePoint: 1) { _ in
            return
        }
    }
}

//
//  CarrotsTests.swift
//  CarrotsTests
//
//  Created by Benjamin Breton on 16/03/2021.
//

import XCTest
import CoreData
@testable import Carrots

class PerformancesTests: XCTestCase {
    
    var game: GameViewModel?
    
    var support: CommonTestsSupport { CommonTestsSupport(game) }
    
    override func setUp() {
        let coreDataStack = FakeCoreDataStack()
        game = GameViewModel(coreDataStack)
        game?.setFactorySettingsBack()
    }
    override func tearDown() {
        game = nil
    }
    
    // MARK: - Add
    
    func testGivenAGameExistsWhenAskToAddPerformanceThenPerformanceHasBeenAdded() throws {
        let game = try XCTUnwrap(self.game)
        guard let athletic = support.addAthletic(), let sport = support.addSport(), game.error == nil else { return }
        game.addPerformance(sport: sport, athletics: [athletic], value: ["100", "0", "0"], addToCommonPot: true)
        XCTAssertNil(game.error)
        XCTAssert(game.performances.count == 1)
        XCTAssert(game.commonPot?.points == 1)
    }
    
    func testGivenAGameExistsWhenAskToAddPerformanceWithPointsInTheCommonAndIndividualPotsThenPerformanceHasBeenAdded() throws {
        let game = try XCTUnwrap(self.game)
        guard let athletic1 = support.addAthletic(), let athletic2 = support.addAthletic(), let sport = support.addSport(), game.error == nil else {
            XCTFail()
            return
        }
        game.addPerformance(sport: sport, athletics: [athletic1, athletic2], value: ["100", "0", "0"], addToCommonPot: true)
        XCTAssertNil(game.error)
        game.addPerformance(sport: sport, athletics: [athletic1, athletic2], value: ["100", "0", "0"], addToCommonPot: false)
        XCTAssertNil(game.error)
        XCTAssert(game.commonPot?.points == 2)
        XCTAssert(game.athletics[0].pot?.points == 1)
        XCTAssert(game.athletics[1].pot?.points == 1)
        XCTAssert(game.performances.count == 2)
    }
    
    // MARK: - Delete
    
    func testGivenPerformancesExistWhenAskToDeleteOneOfThemThenPerformanceIsDeleted() throws {
        let game = try XCTUnwrap(self.game)
        guard let athletic1 = support.addAthletic(), let athletic2 = support.addAthletic(), let sport = support.addSport(), game.error == nil else {
            XCTFail()
            return
        }
        game.addPerformance(sport: sport, athletics: [athletic1, athletic2], value: ["100", "0", "0"], addToCommonPot: true)
        game.addPerformance(sport: sport, athletics: [athletic1, athletic2], value: ["100", "0", "0"], addToCommonPot: false)
        game.delete(game.performances[0])
        XCTAssertNil(game.error)
        XCTAssert(game.performances.count == 1)
    }
    
    func testGivenPerformancesExistWhenAskToDeleteAllOfThemThenPerformancesAreDeleted() throws {
        let game = try XCTUnwrap(self.game)
        guard let athletic1 = support.addAthletic(), let athletic2 = support.addAthletic(), let sport = support.addSport(), game.error == nil else {
            XCTFail()
            return
        }
        game.addPerformance(sport: sport, athletics: [athletic1, athletic2], value: ["100", "0", "0"], addToCommonPot: true)
        game.addPerformance(sport: sport, athletics: [athletic1, athletic2], value: ["100", "0", "0"], addToCommonPot: false)
        game.delete(game.performances[0])
        XCTAssertNil(game.error)
        game.delete(game.performances[0])
        XCTAssert(game.error == nil)
        XCTAssert(game.performances.count == 0)
    }
    func testGivenAPerformanceHasBeenAddedWhenAskingToDeleteItForOneAthleticThenItsDeletedForThisAthletic() throws {
        let game = try XCTUnwrap(self.game)
        guard let athletic1 = support.addAthletic(), let athletic2 = support.addAthletic(), let sport = support.addSport(unityType: .count, pointsConversion: ["1", "0", "0"]), game.error == nil else {
            XCTFail()
            return
        }
        game.addPerformance(sport: sport, athletics: [athletic1, athletic2], value: ["100", "0", "0"], addToCommonPot: true)
        XCTAssertNil(game.error)
        XCTAssert(game.commonPot?.points == 200)
        XCTAssert(game.performances[0].athletics.count == 2)
        game.delete(game.performances[0], of: athletic1)
        XCTAssertNil(game.error)
        XCTAssert(game.performances[0].athletics.count == 1)
        XCTAssert(game.performances[0].athletics[0] == athletic2)
        XCTAssert(game.commonPot?.points == 100)
        game.delete(game.performances[0], of: athletic2)
        XCTAssertNil(game.error)
        XCTAssert(game.performances.count == 0)
        XCTAssert(game.commonPot?.points == 0)
    }
    
    // MARK: - Several tests
    
    func testGivenPerformancesExistsWhenAthleticSportAndPerformancesHasBeenDeletedThenTheyAreSuccessfullyDeletedAndPointsTotalIsCorrect() throws {
        let game = try XCTUnwrap(self.game)
        guard let athletic1 = support.addAthletic(), let athletic2 = support.addAthletic(), let sport = support.addSport(unityType: .count, pointsConversion: ["1", "0", "0"]), game.error == nil else {
            XCTFail()
            return
        }
        game.addPerformance(sport: sport, athletics: [athletic1, athletic2], value: ["15", "0", "0"], addToCommonPot: true)
        XCTAssertNil(game.error)
        game.addPerformance(sport: sport, athletics: [athletic1, athletic2], value: ["30", "0", "0"], addToCommonPot: true)
        XCTAssertNil(game.error)
        game.addPerformance(sport: sport, athletics: [athletic1, athletic2], value: ["100", "0", "0"], addToCommonPot: true)
        XCTAssertNil(game.error)
        game.addPerformance(sport: sport, athletics: [athletic1], value: ["50", "0", "0"], addToCommonPot: true)
        XCTAssertNil(game.error)
        game.delete(athletic1)
        XCTAssertNil(game.error)
        game.addPerformance(sport: sport, athletics: [athletic2], value: ["70", "0", "0"], addToCommonPot: true)
        XCTAssertNil(game.error)
        game.delete(game.performances[3])
        XCTAssertNil(game.error)
        print(game.performances.count)
        game.delete(sport)
        XCTAssertNil(game.error)
        print(game.performances.count)
        XCTAssert(game.performances.count == 4)
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
         - athletic1 deletion : the deletion doesn't change points total, and performances are still there.
         > total : 340
         - performance 5, 1 athletic, so :            +  70pts
         > total : 410
         - performance 2 deletion, so :               -  60pts
         > total : 350
         - sport deletion : the deletion doesn't change points total, and performances are still there
         > total : 350
         */
        XCTAssert(game.commonPot?.points == 350)
    }

}

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
    
    var gameDoor: GameDoor?
    
    override func setUp() {
        let coreDataStack = FakeCoreDataStack()
        gameDoor = GameDoor(coreDataStack)
        gameDoor?.setFactorySettingsBack()
    }
    override func tearDown() {
        gameDoor = nil
    }
    
    // MARK: - Add
    
    func testGivenAGameExistsWhenAskToAddPerformanceThenPerformanceHasBeenAdded() throws {
        let game = try XCTUnwrap(self.gameDoor)
        guard let athletic = addAthletic(), let sport = addSport(), game.error == nil else { return }
        game.addPerformance(sport: sport, athletics: [athletic], value: ["100", "0", "0"], addToCommonPot: true)
        XCTAssertNil(game.error)
        XCTAssert(game.performances.count == 1)
        XCTAssert(game.commonPot?.points == 1)
    }
    
    func testGivenAGameExistsWhenAskToAddPerformanceWithPointsInTheCommonAndIndividualPotsThenPerformanceHasBeenAdded() throws {
        let game = try XCTUnwrap(self.gameDoor)
        guard let athletic1 = addAthletic(), let athletic2 = addAthletic(), let sport = addSport(), game.error == nil else {
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
        let game = try XCTUnwrap(self.gameDoor)
        guard let athletic1 = addAthletic(), let athletic2 = addAthletic(), let sport = addSport(), game.error == nil else {
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
        let game = try XCTUnwrap(self.gameDoor)
        guard let athletic1 = addAthletic(), let athletic2 = addAthletic(), let sport = addSport(), game.error == nil else {
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
        let game = try XCTUnwrap(self.gameDoor)
        guard let athletic1 = addAthletic(), let athletic2 = addAthletic(), let sport = addSport(unityType: .count, pointsConversion: ["1", "0", "0"]), game.error == nil else {
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
    }
    
    // MARK: - Several tests
    
    func testGivenPerformancesExistsWhenAthleticSportAndPerformancesHasBeenDeletedThenTheyAreSuccessfullyDeletedAndPointsTotalIsCorrect() throws {
        let game = try XCTUnwrap(self.gameDoor)
        guard let athletic1 = addAthletic(), let athletic2 = addAthletic(), let sport = addSport(unityType: .count, pointsConversion: ["1", "0", "0"]), game.error == nil else {
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
    
    // MARK: - Supporting methods
    
    @discardableResult
    func addAthletic(_ name: String = UUID().uuidString) -> Athletic? {
        guard let game = gameDoor else { return nil }
        game.addAthletic(name: name, image: nil)
        for athletic in game.athletics {
            if athletic.name == name {
                return athletic
            }
        }
        return nil
    }
    
    @discardableResult
    func addSport(_ name: String = UUID().uuidString, icon: String = "A", unityType: Sport.UnityType = .count, pointsConversion: [String?] = ["100", "0", "0"]) -> Sport? {
        guard let game = gameDoor else { return nil }
        game.addSport(name: name, icon: icon, unityType: unityType, pointsConversion: pointsConversion)
        for sport in game.sports {
            if sport.name == name {
                return sport
            }
        }
        return nil
    }

}

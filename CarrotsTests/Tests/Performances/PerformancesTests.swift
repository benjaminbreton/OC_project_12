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
    
    var gameHandler: GameHandler?
    var game: GameViewModel { gameHandler!.game }
    var support: CommonTestsSupport { gameHandler!.support }

    override func setUp() {
        self.gameHandler = GameHandler()
    }
    override func tearDown() {
        gameHandler = nil
    }
    
    // MARK: - Add
    
    func testGivenAGameExistsWhenAskToAddPerformanceThenPerformanceHasBeenAdded() throws {
        guard let athletic = support.addAthletic(), let sport = support.addSport(), game.error == nil else { return }
        game.addPerformance(sport: sport, athletics: [athletic], value: ["100", "0", "0"], addToCommonPot: true)
        XCTAssertNil(game.error)
        XCTAssert(game.performances.count == 1)
        XCTAssert(athletic.performances.count == 1)
        XCTAssert(game.commonPot?.points == 1)
        XCTAssert(game.performances[0].description == "\(game.performances[0].formattedDate) performance")
        XCTAssert(game.performances[0].formattedValue == "100")
    }
    
    func testGivenAGameExistsWhenAskToAddPerformanceWithPointsInTheCommonAndIndividualPotsThenPerformanceHasBeenAdded() throws {
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
    
    func testGivenPerformancesExistWhenAthleticSportAndPerformancesHasBeenDeletedThenTheyAreSuccessfullyDeletedAndPointsTotalIsCorrect() throws {
        guard let athletic1 = support.addAthletic(), let athletic2 = support.addAthletic(), let sport = support.addSport(unityType: .count, pointsConversion: ["1", "0", "0"]), game.error == nil else {
            XCTFail()
            return
        }
        // Add performance
        game.addPerformance(sport: sport, athletics: [athletic1, athletic2], value: ["15", "0", "0"], addToCommonPot: true)
        /*
         Add performance
         
         Performances count:
         - athletic1        1
         - athletic2        1
         - sport            1
         - game             1
         
         Points count:
         - common pot       15 x 2 = 30
         - athletic1        0
         - athletic2        0
         */
        XCTAssertNil(game.error)
        XCTAssert(athletic1.performances.count == 1)
        XCTAssert(athletic2.performances.count == 1)
        XCTAssert(sport.performances.count == 1)
        XCTAssert(game.performances.count == 1)
        XCTAssert(game.commonPot?.points == 30)
        XCTAssert(athletic1.pot?.points == 0)
        XCTAssert(athletic2.pot?.points == 0)
        // Delete performance of athletic1
        game.delete(game.performances[0], of: athletic1)
        /*
         Delete performance of an athletic : the athletic did not participate to this performance, so points earned because of it have to be canceled.
         
         Performances count:
         - athletic1        0
         - athletic2        1
         - sport            1
         - game             1
         
         Points count:
         - common pot       30 - 15 = 15
         - athletic1        0
         - athletic2        0
         */
        XCTAssertNil(game.error)
        XCTAssert(athletic1.performances.count == 0)
        XCTAssert(athletic2.performances.count == 1)
        XCTAssert(sport.performances.count == 1)
        XCTAssert(game.performances.count == 1)
        XCTAssert(game.commonPot?.points == 15)
        XCTAssert(athletic1.pot?.points == 0)
        XCTAssert(athletic2.pot?.points == 0)
        // Delete performance of athletic2
        game.delete(game.performances[0], of: athletic2)
        /*
         Delete performance of an athletic : the athletic did not participate to this performance, so points earned because of it have to be canceled. Since he was the last performance's athletic, the performance itself has to be deleted.
         
         Performances count:
         - athletic1        0
         - athletic2        0
         - sport            0
         - game             0
         
         Points count:
         - common pot       15 - 15 = 0
         - athletic1        0
         - athletic2        0
         */
        XCTAssertNil(game.error)
        XCTAssert(athletic1.performances.count == 0)
        XCTAssert(athletic2.performances.count == 0)
        XCTAssert(sport.performances.count == 0)
        XCTAssert(game.performances.count == 0)
        XCTAssert(game.commonPot?.points == 0)
        XCTAssert(athletic1.pot?.points == 0)
        XCTAssert(athletic2.pot?.points == 0)
        // Add performance
        game.addPerformance(sport: sport, athletics: [athletic1, athletic2], value: ["15", "0", "0"], addToCommonPot: true)
        /*
         Add performance
         
         Performances count:
         - athletic1        1
         - athletic2        1
         - sport            1
         - game             1
         
         Points count:
         - common pot       15 x 2 = 30
         - athletic1        0
         - athletic2        0
         */
        XCTAssertNil(game.error)
        XCTAssert(athletic1.performances.count == 1)
        XCTAssert(athletic2.performances.count == 1)
        XCTAssert(sport.performances.count == 1)
        XCTAssert(game.performances.count == 1)
        XCTAssert(game.commonPot?.points == 30)
        XCTAssert(athletic1.pot?.points == 0)
        XCTAssert(athletic2.pot?.points == 0)
        // Add performance
        game.addPerformance(sport: sport, athletics: [athletic1, athletic2], value: ["30", "0", "0"], addToCommonPot: true)
        /*
         Add performance
         
         Performances count:
         - athletic1        2
         - athletic2        2
         - sport            2
         - game             2
         
         Points count:
         - common pot       30 + 30 x 2 = 90
         - athletic1        0
         - athletic2        0
         */
        XCTAssertNil(game.error)
        XCTAssert(athletic1.performances.count == 2)
        XCTAssert(athletic2.performances.count == 2)
        XCTAssert(sport.performances.count == 2)
        XCTAssert(game.performances.count == 2)
        XCTAssert(game.commonPot?.points == 90)
        XCTAssert(athletic1.pot?.points == 0)
        XCTAssert(athletic2.pot?.points == 0)
        // Add performance
        game.addPerformance(sport: sport, athletics: [athletic1, athletic2], value: ["100", "0", "0"], addToCommonPot: true)
        /*
         Add performance
         
         Performances count:
         - athletic1        3
         - athletic2        3
         - sport            3
         - game             3
         
         Points count:
         - common pot       90 + 100 x 2 = 290
         - athletic1        0
         - athletic2        0
         */
        XCTAssertNil(game.error)
        XCTAssert(athletic1.performances.count == 3)
        XCTAssert(athletic2.performances.count == 3)
        XCTAssert(sport.performances.count == 3)
        XCTAssert(game.performances.count == 3)
        XCTAssert(game.commonPot?.points == 290)
        XCTAssert(athletic1.pot?.points == 0)
        XCTAssert(athletic2.pot?.points == 0)
        // Add performance
        game.addPerformance(sport: sport, athletics: [athletic1], value: ["50", "0", "0"], addToCommonPot: true)
        /*
         Add performance
         
         Performances count:
         - athletic1        4
         - athletic2        3
         - sport            4
         - game             4
         
         Points count:
         - common pot       290 + 50 = 340
         - athletic1        0
         - athletic2        0
         */
        XCTAssertNil(game.error)
        XCTAssert(athletic1.performances.count == 4)
        XCTAssert(athletic2.performances.count == 3)
        XCTAssert(sport.performances.count == 4)
        XCTAssert(game.performances.count == 4)
        XCTAssert(game.commonPot?.points == 340)
        XCTAssert(athletic1.pot?.points == 0)
        XCTAssert(athletic2.pot?.points == 0)
        // Delete athletic
        game.delete(athletic1)
        /*
         Delete athletic. The deletion has no effect on common pot points, because performances have been made anyway.
         
         Performances count:
         - athletic2        3
         - sport            4
         - game             4
         
         Points count:
         - common pot       340
         - athletic2        0
         */
        XCTAssertNil(game.error)
        XCTAssert(athletic2.performances.count == 3)
        XCTAssert(sport.performances.count == 4)
        XCTAssert(game.performances.count == 4)
        XCTAssert(game.commonPot?.points == 340)
        XCTAssert(athletic2.pot?.points == 0)
        // Add performance
        game.addPerformance(sport: sport, athletics: [athletic2], value: ["70", "0", "0"], addToCommonPot: true)
        /*
         Add performance
         
         Performances count:
         - athletic2        4
         - sport            5
         - game             5
         
         Points count:
         - common pot       340 + 70 = 410
         - athletic2        0
         */
        XCTAssertNil(game.error)
        XCTAssert(athletic2.performances.count == 4)
        XCTAssert(sport.performances.count == 5)
        XCTAssert(game.performances.count == 5)
        XCTAssert(game.commonPot?.points == 410)
        XCTAssert(athletic2.pot?.points == 0)
        // Delete performance
        game.delete(game.performances[3])
        /*
         Delete performance. This deletion will cancel earned points.
         
         Performances count:
         - athletic2        3
         - sport            4
         - game             4
         
         Points count:
         - common pot       410 - 60 = 350
         - athletic2        0
         */
        XCTAssertNil(game.error)
        XCTAssert(athletic2.performances.count == 3)
        XCTAssert(sport.performances.count == 4)
        XCTAssert(game.performances.count == 4)
        XCTAssert(game.commonPot?.points == 350)
        XCTAssert(athletic2.pot?.points == 0)
        // Delete sport
        game.delete(sport)
        /*
         Delete sport. The deletion has no effect on common pot points, because performances have been made anyway.
         
         Performances count:
         - athletic2        3
         - game             4
         
         Points count:
         - common pot       350
         - athletic2        0
         */
        XCTAssertNil(game.error)
        XCTAssert(athletic2.performances.count == 3)
        XCTAssert(game.performances.count == 4)
        XCTAssert(game.commonPot?.points == 350)
        XCTAssert(athletic2.pot?.points == 0)
    }

}

//
//  CarrotsTests.swift
//  CarrotsTests
//
//  Created by Benjamin Breton on 16/03/2021.
//

import XCTest
import CoreData
@testable import Carrots

class EvolutionTests: XCTestCase {
    
    var gameHandler: GameHandler?
    var game: GameViewModel { gameHandler!.game }
    var support: CommonTestsSupport { gameHandler!.support }

    override func setUp() {
        self.gameHandler = GameHandler(Date().today - 45 * 24 * 3600)
    }
    override func tearDown() {
        gameHandler = nil
    }
    
    func testGivenAGameHasBeenCreated45daysAgoWhenAddingPerformancesThenEvolutionsAreOk() throws {
        // day - 45 : create athletic and sport
        
        let athletic = try XCTUnwrap(support.addAthletic())
        XCTAssertNil(game.error)
        let sport = try XCTUnwrap(support.addSport())
        XCTAssertNil(game.error)
        // the athletic has just been created, so his evolution has the "same" value
        XCTAssert(athletic.pot?.evolution.image.name == "arrow.right.square")
        XCTAssert(athletic.pot?.evolution.image.color == "yellow")
        // reload game on day - 45 to test the evolutiondatas count
        gameHandler?.reloadGame(for: Date().today - 45 * 24 * 3600)
        XCTAssert(game.athletics[0].evolutionDatas.count == 1)
        
        // day - 31 : add performance
        
        gameHandler?.reloadGame(for: Date().today - 31 * 24 * 3600)
        // no performance has been made on day - 45, so the evolution is same
        XCTAssert(athletic.pot?.evolution.image.name == "arrow.right.square")
        XCTAssert(athletic.pot?.evolution.image.color == "yellow")
        // add performance
        game.addPerformance(sport: sport, athletics: [athletic], value: ["10000", "", ""], addToCommonPot: false, date: Date().now - 31 * 24 * 3600)
        XCTAssertNil(game.error)
        
        // day - 29 : add performance
        
        gameHandler?.reloadGame(for: Date().today - 29 * 24 * 3600)
        // a performance has been made on day - 31, so the evolution is up
        XCTAssert(athletic.pot?.evolution.image.name == "arrow.up.right.square")
        XCTAssert(athletic.pot?.evolution.image.color == "lightGreen")
        // add performance
        game.addPerformance(sport: sport, athletics: [athletic], value: ["5000", "", ""], addToCommonPot: true, date: Date().now - 29 * 24 * 3600)
        XCTAssertNil(game.error)
        
        // day D : check conditions of success
        
        gameHandler?.reloadGame()
        XCTAssert(game.athletics.count == 1)
        XCTAssert(game.performances.count == 2)
        // points = 10000 / 100 = 100
        XCTAssert(athletic.pot?.points == 100)
        // amount = 100 points = 1 $
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        XCTAssert(athletic.pot?.formattedAmount == formatter.string(from: 1))
        // prediction = amount (1) + prediction : points per hour (100 / 1080) x number of hours (30 * 24) / points for one $ (100)
        let prediction: Double = 100 / 1080 * 30 * 24 / 100
        XCTAssert(athletic.pot?.formattedPredictionAmount == formatter.string(from: NSNumber(value: 1 + prediction)))
        // a performance has been made on day - 29, but only for the common pot. The athletic's pot's evolution is down, the common pot's is up.
        XCTAssert(athletic.pot?.evolution.image.name == "arrow.down.right.square")
        XCTAssert(athletic.pot?.evolution.image.color == "red")
        XCTAssert(game.commonPot?.evolution.image.name == "arrow.up.right.square")
        XCTAssert(game.commonPot?.evolution.image.color == "lightGreen")
        // There are 3 evolutiondatas : today, today-29, and today-31 to have an evolution on 30 days. Today-31 is essential because there's no evolution for today-30. Today-45 has to be deleted.
        XCTAssert(athletic.evolutionDatas.count == 3)
        XCTAssert(game.commonPot?.evolutionDatas.count == 3)
        XCTAssert(athletic.pot?.evolutionDatas.count == 3)
        // The first evolution has to be Today-31.
        XCTAssert(athletic.evolutionDatas[0].date == Date().today - 31 * 24 * 3600)
    }

}
